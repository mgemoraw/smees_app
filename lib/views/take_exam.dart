import "dart:async";
import "dart:convert";
import 'package:http/http.dart' as http;
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:provider/provider.dart";
import "package:smees/models/database.dart";
import "package:smees/models/smees_test.dart";
import "package:smees/models/test_model.dart";
import "package:smees/models/user.dart";
import "package:smees/views/answer_option.dart";
import "package:smees/views/result_page.dart";
import "package:smees/views/user_provider.dart";
import "package:smees/views/utils.dart";

import "../api/end_points.dart";

class TakeExam extends StatefulWidget {
  final String department;
  final TestSchema examData;
  final List items;
  // final int examId;
  const TakeExam({
    super.key,
    required this.department,
    required this.items,
    // required this.examId,
    required this.examData,
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
  Map <dynamic, dynamic> _userAnswers = {};
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
    // _scrollController.animateTo(
    //   _qno * 100.0,
    //   duration: Duration(milliseconds:300),
    //   curve: Curves.easeInOut,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final useModeProvider = Provider.of<UseModeProvider>(context);
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async{
            // check answer
            // _calculateScore();
            if (userAnswers.length == widget.items.length ) {
              _calculateScore();
              final result = {
                'userId': userProvider.user.username,
                'examStarted': DateTime.now().toIso8601String(),
                'examEnded': DateTime.now().toIso8601String(),
                'questions': widget.items.length,
                'score': _totalScore,
              };

              if (useModeProvider.offlineMode){
                await _writeResults(result);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResultPage(resultData:
                        result, backRoute: "/exam")));
              } else {


                // send results to database
                await _sendResults(Exam(
                  id: widget.examData.id,
                  userId: userProvider.user.username,
                  examStarted: DateTime.now(),
                  examEnded: DateTime.now(),
                  questions: widget.items.length,
                  score: _totalScore.toDouble(),
                ));

                // navigate to results page after submission
                if (_message == "success" ){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultPage(resultData:
                          result, backRoute: "/exam")));
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                      SnackBar(
                        content: Text("Submit Failed with Error $_message",
                            style:
                            TextStyle(fontSize: 15, color: Colors.blue[900])),
                        backgroundColor: Colors.red[300],
                      ));
                }
              }
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                  SnackBar(
                    content: Text("Please Complete all Questions", style: TextStyle(fontSize: 15, color: Colors.blue[900])),
                    backgroundColor: Colors.red[300],
              ));
            }
            // print("Hello: $_totalScore");
          },
          isExtended: true,
          child: isLoading? CircularProgressIndicator() : Icon(
            Icons.send,
          ), //Icons.plus),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        // backgroundColor: Color.fromRGBO(33, 150, 243, 1),
        title: Text(
          "Exam Time - ${_formatTime(_remainingTime)}  ",
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

                    // calculate score
                    _calculateScore();

                    final result = {
                      'userId': userProvider.user.username,
                      'examStarted': DateTime.now().toIso8601String(),
                      'examEnded': DateTime.now().toIso8601String(),
                      'questions': widget.items.length,
                      'score': _totalScore,
                    };


                    // writes data to local database
                    await _writeResults(result);

                    if (!useModeProvider.offlineMode){
                      await _sendResults(new Exam(
                        id: widget.examData.id,
                        userId: userProvider.user.username,
                        examStarted: DateTime.now(),
                        examEnded: DateTime.now(),
                        questions: widget.items.length,
                        score: _totalScore.toDouble(),

                      ));
                    }
                    // sends data to database

                    // Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultPage(resultData:
                            result, backRoute: "/exam")));
                  },
                  child: isLoading ? CircularProgressIndicator(): Text
                    ("Submit Result"),
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
            SizedBox(
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

            // adding image when there exists
            (widget.items[_qno]['image'] != null && widget
                .items[_qno]['image'] != "") ?
            useModeProvider.offlineMode ?
              Image.asset(getImagePath(widget.department, widget
                  .items[_qno]['image'])!)

                    : Image.network
              ("http://localhost:8000/static/images/${widget
                .items[_qno]['image']}")
            : SizedBox(height: 1,),

            // answer options
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.items[_qno]['options'].length,
              itemBuilder: (context, index) {
                try {
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

                          // storing user answer to _userAnswers map
                          _userAnswers[widget.items[_qno]['id']] =
                          _chosenAnswer!;

                          debugPrint(_userAnswers.toString());
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
                } else {
                  return null;
                }
                } catch(eror){
                  //
                  // debugPrint("Wrong options format");
                  return Container(
                    child:Center(
                      child: Text("No Choices found"),
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
    // write answer
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

  void _calculateScore(){
    int score = 0;
    for (int i = 0; i < userAnswers.length; i++) {
      if (userAnswers[i] == widget.items[i]['answer']) {
        score++;
        print("Answer $i: ${widget.items[i]['answer']} user Answer $i: ${userAnswers[i]}");
        print("Score: $score");
      }
    }

    setState(() {
      _totalScore = score;
    });
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
      // debugPrint("Error: $err");
    } finally {
      setState(() {
        _message = "";
      });
      // debugPrint(_message);
    }
  }

  Future<void> _sendResults(Exam exam)
  async {
    final url = Uri.parse('$API_BASE_URL$testSubmitApi/${exam.id}');
    const storage = FlutterSecureStorage();
    // final token = storage.read(key: "smees-token");
    final token = userProvider.user.password;
    debugPrint("Token: $token");

    final headers = {
      'Authorization': "Bearer $token",
      "Content-Type": "application/json",
    };

    // Convert the userAnswers Map to a serializable one
    Map<String, dynamic> serializableUserAnswers = {};
    _userAnswers.forEach((key, value) {
      // Convert key to String (if it's not already a string)
      // Convert value to JSON-serializable type
      serializableUserAnswers[key.toString()] = value is String || value is num || value is bool
          ? value
          : value.toString();  // Convert non-serializable types to String (or handle them as needed)
    });

    try {
      final  testData = {
        "id": exam.id,
        "userId": exam.userId,
        "examStarted": exam.examStarted!.toIso8601String(),
        "examEnded": exam.examEnded!.toIso8601String(),
        "questions": exam.questions,
        "score": exam.score,
        "userAnswers": serializableUserAnswers,
      };
      // final body = json.encode({
      //   "id": testData['id'],
      //   "userId": testData['userId'],
      //   "examStarted": testData['examStarted'],
      //   "examEnded": testData['examEnded'],
      //   "questions": testData['questions'],
      //   "score": testData['score'],
      //   "userAnswers": testData['userAnswers'],
      // });


      debugPrint(testData.toString());

      //
      final response = await http.post(
        url,
        body: json.encode(testData),
        headers: headers,
      );
      if (response.statusCode == 200) {
        setState(() {
          _message = "success";
        });
      } else {
        setState(()  {
          _message = jsonEncode(response.body!);
        });
        debugPrint(response.body);
    }

    } catch (err) {
      //
      debugPrint("Sending data failed $err");
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


