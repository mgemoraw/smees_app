import "dart:async";
import "dart:convert";
import 'package:http/http.dart' as http;
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:provider/provider.dart";
import "package:smees/models/database.dart";
import "package:smees/models/test_model.dart";
import "package:smees/models/user.dart";
import "package:smees/views/answer_option.dart";
import "package:smees/views/result_page.dart";
import "package:smees/views/user_provider.dart";

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
  // User? user;
  late UserProvider userProvider;
  DateTime? testStarted;
  DateTime? testEnded;
  late String _message = '';
  bool isLoading = false;

  String bottomContainerText = "";
  Map userAnswers = {};
  int _qno = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;
  String? _chosenAnswer;
  Color? _selectedColor;
  Color? selectedColor = Colors.grey[500];
  final Color? _bgColor = null;
  Timer? _timer;
  Duration _remainingTime = Duration(hours: 0, minutes: 0, seconds: 0);

  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _qnoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setExamTime();
    _loadUserData();
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadUserData() {
    final userProv = Provider.of<UserProvider>(context, listen:false);
    setState(() {
      userProvider = userProv;
    });

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

  void scrollToIndex() {
    _scrollController.animateTo(
      _qno * 100.0,
      duration: Duration(milliseconds:300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final useModeProvider = Provider.of<UseModeProvider>(context);
    final user = Provider.of<UserProvider>(context).user;

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
                  onPressed: () async{
                    // _previous question
                    // _restartQuiz();

                    final result = {
                      'userId': userProvider.user.username,
                      'examStarted': DateTime.now().toIso8601String(),
                      'examEnded': DateTime.now().toIso8601String(),
                      'questions': widget.items.length,
                      'score': _totalScore,
                    };
                    await _writeResults(result);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultPage(resultData:
                            result, backRoute: "/exam")));
                  },
                  child: const Text("Submit Result"),
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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            TextField(
              controller: _qnoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                helperText: 'Search by Question No',
                hintText: "Search by Question No"
              ),
              onChanged: (value) {
                if (value.isNotEmpty){
                  int num = int.parse(value);
                  if (num >0 && num < widget.items.length){
                    setState(() {
                      _qno = num - 1;
                    });
                  }
                }
              },
            ),
            // Question index tracker
            Container(
              height: 60.0,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // controller: _scrollController,
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
                            // scroll to index
                            scrollToIndex();
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              userAnswers[index] == null ? null : Colors.grey[500],
                        ),
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(fontSize: (_qno == index ? 22 : 15), fontWeight: FontWeight
                              .bold, color:  (_qno == index ? Colors.green[900] : null)),
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
          _selectedColor = null;
          bottomContainerText = "";
        }
        // scroll to index
        scrollToIndex();
      } else {
        // final result = {
        //   'userId': userProvider.user.username,
        //   'examStarted': DateTime.now().toIso8601String(),
        //   'examEnded': DateTime.now().toIso8601String(),
        //   'questions': widget.items.length,
        //   'score': _totalScore,
        // };
        // Navigator.pop(context);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ResultPage(resultData: result)));
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
        // scroll to index
        scrollToIndex();
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
      _selectedColor = Colors.grey[500];
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


  Future<void> _writeResults(Map<String, dynamic> data) async {
    try {
      await SmeesHelper().addExam(data);
      setState(() {
        _message = "success";
      });
    } catch (err) {
      // print("Writing data failed $err");
      setState((){
        _message = "Error: Something went wrong!";
      });
      print("Error: $err");
    } finally {
      print(_message);
    }
  }

  Future<void> _sendResults(Exam exam) async {
    final url = Uri.parse('$API_BASE_URL/$testSubmitApi');
    const storage = FlutterSecureStorage();
    final token = storage.read(key: "smees-token");
    final headers = {
      'Authentication': "Bearer $token",
      'ContentType': 'application/json',
    };
    final body = exam.toMap();

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


