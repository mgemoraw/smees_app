import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smees/api/end_points.dart';
import 'package:smees/models/database.dart';
import 'package:smees/models/test_model.dart';

import 'package:smees/views/answer_option.dart';

import 'package:smees/views/result_page.dart';
import 'package:smees/views/user_provider.dart';

class TakeQuiz extends StatefulWidget {
  final String department;
  final List items;

  const TakeQuiz({super.key, required this.department, required this.items});

  @override
  State<TakeQuiz> createState() => _TakeQuizState();
}

class _TakeQuizState extends State<TakeQuiz> {
  // varaibles
  String bottomContainerText = "";
  Map userAnswers = {};
  int _qno = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;
  String? _chosenAnswer;
  Color? _selectedColor;
  Timer? _timer;
  int _start = 60;
  DateTime testStarted = DateTime.now();
  String _message = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useModeProvider = Provider.of<UseModeProvider>(context);
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        // backgroundColor: Color.fromRGBO(33, 150, 243, 1),
        title: Text("Quiz - ${widget.department} Time: $_start seconds"),
        actions: [
          // working on search bar
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: TextButton(
                  child: Text("About Us"),
                  onPressed: () {},
                ),
              ),
              PopupMenuItem(
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ),
              PopupMenuItem(
                child: IconButton(
                  icon: const Icon(Icons.exit_to_app_sharp),
                  onPressed: () {
                    // exit logic here
                  },
                ),
              ),
            ];
          }),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ElevatedButton(
              onPressed: () {
                // _previous question
                _previous_quesion();
              },
              child: const Row(children: [
                Icon(Icons.arrow_back),
                Text("Previous"),
              ])),

          // restart button
          (_qno >= widget.items.length - 1)
              ? ElevatedButton(
                  onPressed: () {
                    // _previous question
                    _restartQuiz();
                  },
                  child: Text("Restart"),
                )
              : Text(""),
          // forward button
          (_qno >= widget.items.length - 1)
              ? ElevatedButton(
                  onPressed: () async {
                    // write score to database
                    final resultData = {
                      'userId': user.username,
                      'testStarted': testStarted.toIso8601String(),
                      'testEnded': DateTime.now().toIso8601String(),
                      'questions': widget.items.length,
                      'score': _totalScore,
                    };

                    if (useModeProvider.offlineMode) {
                      await _writeResults(resultData);
                    } else {
                      // await _sendResults(Test());
                    }

                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ResultPage(score: _totalScore)));
                  },
                  child: Text("Result"))
              : ElevatedButton(
                  onPressed: () {
                    // _previous question
                    _nextQuestion();
                  },
                  child: const Row(children: [
                    Icon(Icons.arrow_forward),
                    Text("Next"),
                  ])),
        ]),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          // Question
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "${_qno + 1}. ${widget.items[_qno]['content']}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            itemCount: !useModeProvider.offlineMode
                ? jsonDecode(widget.items[_qno]['options']).length
                : (widget.items[_qno]['options']).length,
            itemBuilder: (context, index) {
              final options = !useModeProvider.offlineMode
                  ? jsonDecode(widget.items[_qno]['options'])
                  : (widget.items[_qno]['options']);
              // if (widget.items[_qno]['options'][index]['content'] != null) {
              if (options[index]['content'] != null) {
                return AnswerOption(
                  enabled: !answerWasSelected,
                  value: options[index]['label'],
                  answerText: options[index]['content'],
                  answerColor: (_chosenAnswer == options[index]['label'])
                      ? _selectedColor!
                      : null,
                  answerTap: () {
                    //
                    setState(() {
                      _selectedColor = Colors.blue;
                      _chosenAnswer = options[index]['label'];
                      _writeAnswer(_chosenAnswer!);
                      disableOptions();
                      // _nextQuestion();
                    });
                  },
                );
              }
            },
          ),

          // Answer Notification container
          Container(
            child: Text(
              bottomContainerText,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),
        ]),
      ),
    );
  }

  void _writeAnswer(String value) {
    userAnswers[_qno] = value;
  }

  void disableOptions() {
    setState(() {
      if (userAnswers[_qno] != null){
        answerWasSelected = true;
        validateAnswer();
      }
    });
  }

  void validateAnswer() {
    // answer logic here
    var correctAnswer = widget.items[_qno]['answer'];
    setState(() {
      if (_chosenAnswer == widget.items[_qno]['answer']) {
        bottomContainerText = "You Answered Right";
        _totalScore++;
        userAnswers[_qno] = _chosenAnswer;
      } else {
        bottomContainerText = "Answer is  $correctAnswer";
      }
    });
  }
  void _checkPreviousAnswer() {
    // logic here
    setState(() {
      _chosenAnswer = userAnswers[_qno];
      _selectedColor = Colors.blue;
      disableOptions();
    });
  }

  void _showUserAnswer(qno) {
    setState(() {
      if (userAnswers[qno] != null) {
        _chosenAnswer = userAnswers[qno];
      } else {
        _chosenAnswer = null;
      }
    });
  }

  void _nextQuestion() {
    // next question
    setState(() {
      if (_qno < widget.items.length - 1) {
        _qno += 1;
        if (_previousAnswer()) {
          _checkPreviousAnswer();
        } else {
          answerWasSelected = false;
          _selectedColor = Colors.white;
          bottomContainerText = "";
        }
        
      }
    });
  }

  void _previous_quesion() {
    setState(() {
      if (_qno > 0) {
        _qno--;
        if (_previousAnswer()) {
          _checkPreviousAnswer();
        } else {
          // _selectedColor = Colors.white;
          answerWasSelected = false;
          _selectedColor = Colors.white;
          bottomContainerText = "";
        }
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/quiz");
    });
  }

  bool _previousAnswer() {
    if (userAnswers[_qno] != null) {
      return true;
    }
    return false;
  }

  Future<void> _writeResults(Map<String, dynamic> data) async {
    try {
      await SmeesHelper().addTest(data);
    } catch (err) {
      print("Writing data failed $err");
    }
  }

  Future<void> _sendResults(Test test) async {
    final url = Uri.parse('$API_BASE_URL/$testSubmitApi');
    const storage = FlutterSecureStorage();
    final token = storage.read(key: "smees-token");
    final headers = {
      'Authentication': "Bearer $token",
      'ContentType': 'application/json',
    };
    final body = test.toMap();

    try {
      //
      final response = await http.post(
        url,
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = "success";
        });
      }
    } catch (err) {
      //
      print("Sending data failed $err");
      setState(() {
        _message = "$err";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
