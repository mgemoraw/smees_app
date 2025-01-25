import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:smees/views/answer_option.dart';

import 'package:smees/views/result_page.dart';

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
  List<Map> userAnswers = [];
  int _qno = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;
  String _chosenAnswer = "";
  Color? _selectedColor;
  Timer? _timer;
  int _start = 60;

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
              child: Row(children: [
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
          ElevatedButton(
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

          
          // option A
          AnswerOption(
              value: 'A',
              answerText: jsonDecode(widget.items[_qno]['options'])['A'],
              enabled: !answerWasSelected,
              answerColor:
                  (_chosenAnswer == 'A') ? _selectedColor! : Colors.white,
              answerTap: () {
                setState(() {
                  _selectedColor = Colors.blue;
                  _chosenAnswer = "A";
                  disableOptions();
                  // _nextQuestion();
                });
              }),

          // option B
          AnswerOption(
              value: 'B',
              answerText: jsonDecode(widget.items[_qno]['options'])['B'],
              enabled: !answerWasSelected,
              answerColor:
                  (_chosenAnswer == 'B') ? _selectedColor! : Colors.white,
              answerTap: () {
                setState(() {
                  _selectedColor = Colors.blue;
                  _chosenAnswer = "B";
                  disableOptions();
                  // _nextQuestion();
                });
              }),

          AnswerOption(
              value: 'C',
              answerText: jsonDecode(widget.items[_qno]['options'])['C'],
              enabled: !answerWasSelected,
              answerColor:
                  (_chosenAnswer == 'C') ? _selectedColor! : Colors.white,
              answerTap: () {
                _selectedColor = Colors.blue;
                _chosenAnswer = "C";
                disableOptions();
                // _nextQuestion();
              }),

          // option D
          AnswerOption(
              value: 'D',
              answerText: jsonDecode(widget.items[_qno]['options'])['D'],
              answerColor:
                  (_chosenAnswer == 'D') ? _selectedColor! : Colors.white,
              enabled: !answerWasSelected,
              answerTap: () {
                setState(() {
                  _selectedColor = Colors.blue;
                  _chosenAnswer = "D";
                  disableOptions();
                  // _nextQuestion();
                });
              }),

          // if option E exists
          (jsonDecode(widget.items[_qno]['options'])['E'] != null)
              ? Container(
                  color: _chosenAnswer == 'E' ? _selectedColor : Colors.white12,
                  child: ListTile(
                    // on tap answer will be submitted
                    onTap: () {
                      setState(() {
                        _chosenAnswer = "E";
                        disableOptions();
                        // _nextQuestion();
                      });
                    },
                    key: Key('E'),
                    leading: const Text(
                      'E.',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    title: Text(
                      jsonDecode(widget.items[_qno]['options'])['E'],
                      style:
                          const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    enabled: !answerWasSelected,
                  ),
                )
              : Text(""),

          // if option F exists
          (jsonDecode(widget.items[_qno]['options'])['F'] != null)
              ? Container(
                  color: _chosenAnswer == 'F' ? _selectedColor : Colors.white12,
                  child: ListTile(
                    // on tap answer will be submitted
                    onTap: () {
                      setState(() {
                        _chosenAnswer = 'F';
                        disableOptions();
                        // _nextQuestion();
                      });
                    },
                    key: Key('F'),
                    leading: Text(
                      'F.',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    title: Text(
                      jsonDecode(widget.items[_qno]['options'])['F'],
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    enabled: !answerWasSelected,
                  ),
                )
              : const Text(""),

          // Answer Notification container
          Container(
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
      answerWasSelected = true;
      validateAnswer();
    });
  }

  void validateAnswer() {
    // answer logic here
    var correctAnswer = widget.items[_qno]['answer'];
    setState(() {
      if (_chosenAnswer == widget.items[_qno]['answer']) {
        bottomContainerText = "You Answered Right";
        _totalScore++;
      } else {
        bottomContainerText = "Answer is  $correctAnswer";
      }
    });
  }

  void _nextQuestion() {
    // next question
    setState(() {
      if (_qno < widget.items.length - 1) {
        _qno += 1;
        answerWasSelected = false;
        _selectedColor = Colors.white;
        bottomContainerText = "";
      } else {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultPage(score: _totalScore)));
      }
    });
  }

  void _previous_quesion() {
    setState(() {
      if (_qno > 0) {
        _qno--;
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      Navigator.pop(context);
      Navigator.pushNamed(context, "/quiz");
    });
  }
}
