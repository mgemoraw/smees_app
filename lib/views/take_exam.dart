import "dart:async";
import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:smees/models/user.dart";
import "package:smees/views/answer_option.dart";
import "package:smees/views/result_page.dart";

import "../api/end_points.dart";

class TakeExam extends StatefulWidget {
  final String department;
  final List items;
  final int examId;
  const TakeExam({
    super.key,
    required this.department,
    required this.items,
    required this.examId,
  });

  @override
  State<TakeExam> createState() => _TakeExamState();
}

class _TakeExamState extends State<TakeExam> {
  // varaibles
  User? user;
  DateTime? testStarted;
  DateTime? testEnded;

  String bottomContainerText = "";
  Map userAnswers = {};
  int _qno = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;
  String? _chosenAnswer;
  Color? _selectedColor;
  Color? selectedColor = Colors.blue;
  final Color? _bgColor = null;
  Timer? _timer;
  Duration _remainingTime = Duration(hours: 0, minutes: 0, seconds: 0);

  @override
  void initState() {
    super.initState();
    _setExamTime();
  }

  void _setExamTime() {
    setState(() {
      _remainingTime = Duration(seconds: widget.items.length * 60);
    });

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });
      } else {
        setState(() {
          timer.cancel();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    // Return time in hh:mm:ss format
    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {},
          isExtended: true,
          child: const Text(
            "Submit", // Display the formatted time
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ), //Icons.plus),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        // backgroundColor: Color.fromRGBO(33, 150, 243, 1),
        title: Text(
          "Exam Time - ${_formatTime(_remainingTime)} - ${widget.department} ",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          // working on search bar
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: TextButton(
                  child: const Text("About Us"),
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
        decoration: const BoxDecoration(
          // color: Theme.of(context).primaryColor,
          color: Colors.white12,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ElevatedButton(
              onPressed: () {
                // go to previous question
                _previousQuesion();
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
                  child: const Text("Restart"),
                )
              : const Text(""),
          // forward button
          ElevatedButton(
              onPressed: () {
                // next question
                _nextQuestion();
              },
              child: const Row(children: [
                Text("Next"),
                Icon(Icons.arrow_forward),
              ])),
        ]),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          // Question index tracker
          Container(
            height: 60,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          // go to question number index+1
                          _qno = index;
                          _chosenAnswer = userAnswers[index];
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            userAnswers[index] == null ? null : Colors.blue,
                      ),
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight
                            .bold),
                      ),
                    ),
                  );
                }),
          ),

          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "${_qno + 1}. ${widget.items[_qno]['content']}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),

          // answer options
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.items[_qno]['options'].length,
            itemBuilder: (context, index) {
              String? option = widget.items[_qno]['options'][index]['content'];
              if (option != null) {
                return Container(
                  padding: const EdgeInsets.all(5.0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: _chosenAnswer ==
                            widget.items[_qno]['options'][index]['label']
                        ? _selectedColor
                        : _bgColor,
                  ),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        _selectedColor = selectedColor;
                        _chosenAnswer =
                            widget.items[_qno]['options'][index]['label'];
                        _writeAnswer(_chosenAnswer!);
                      });
                    },
                    leading: Text(
                      widget.items[_qno]['options'][index]['label'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    title: Text(widget.items[_qno]['options'][index]['content'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15)),
                    selectedTileColor: _selectedColor,
                    //textColor: Colors.blue,
                    enabled: !answerWasSelected,
                  ),
                );
              }
            },
          ),

          // Answer Notification container
          Container(
            color: Colors.white,
            child: Text(
              bottomContainerText,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            //"YOur answer progress"),
          ),
        ]),
      ),
    );
  }

  void disableOptions() {
    setState(() {
      answerWasSelected = false;
      validateAnswer();
    });
  }

  void validateAnswer() {
    // answer logic here
    var correctAnswer = widget.items[_qno]['answer'];
    setState(() {
      if (_chosenAnswer == correctAnswer) {
        // increase total score by 1 for every right and
        _totalScore++;
        userAnswers[_qno] = _chosenAnswer;
      }
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

//
      } else {
        final result = {
          'userId': user!.username,
          'testStarted': testStarted!.toIso8601String(),
          'testEnded': DateTime.now().toIso8601String(),
          'questions': widget.items.length,
          'score': _totalScore,
        };
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultPage(resultData: result)));
      }
    });
  }

  void _previousQuesion() {
    setState(() {
      if (_qno > 0) {
        _qno--;
        //_selectedColor = Colors.white12;
        if (_previousAnswer()) {
          _checkPreviousAnswer();
        } else {
          _selectedColor = _bgColor;
        }
      }
    });
  }

  void _writeAnswer(String value) {
    userAnswers[_qno] = value;

  }

  void _checkPreviousAnswer() {
    // logic here
    setState(() {
      _chosenAnswer = userAnswers[_qno];
      _selectedColor = Colors.blue;
    });
  }

  void _restartQuiz() {
    Navigator.pop(context);
    Navigator.pushNamed(context, "/exam");
  }

  bool _previousAnswer() {
    if (userAnswers[_qno] != null) {
      return true;
    }
    return false;
  }


  Future <void> writeAnswerToDatabase(String answerLabel, qid) async {
    
  late String? message = "";
  final url = Uri.parse('$API_BASE_URL/$testSubmitApi');

  final storage = FlutterSecureStorage();
  final token = await storage.read(key:"smees_token");


  final headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authentication': 'Bearer $token'
    };
  // final headers = {"Content-Type": "application/json"};

  final body = {
    'username': "",
    'password': "",
  };

  }

  
}
