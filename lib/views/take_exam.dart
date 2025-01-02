import "package:flutter/material.dart";
import "package:smees/views/answer_option.dart";
import "package:smees/views/result_page.dart";

class TakeExam extends StatefulWidget {
  final String department;
  final List items;
  const TakeExam({
    super.key,
    required this.department,
    required this.items,
  });

  @override
  State<TakeExam> createState() => _TakeExamState();
}

class _TakeExamState extends State<TakeExam> {
  // varaibles
  List<Icon> _scoreTracker = [];
  String bottomContainerText = "";
  Map userAnswers = {};
  int _qno = 0;
  int _qid = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;
  String _chosenAnswer = "";
  Color? _selectedColor;
  final Color _bgColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        // backgroundColor: Color.fromRGBO(33, 150, 243, 1),
        title: Text("Quiz - ${widget.department}"),
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
              "${_qno + 1}. ${widget.items[_qno]['question']}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),

          // option A
          Container(
            color: _chosenAnswer == 'A' ? _selectedColor : _bgColor,
            child: ListTile(
              onTap: () {
                setState(() {
                  _selectedColor = Colors.blue;
                  _chosenAnswer = "A";
                  _writeAnswer(_chosenAnswer);
                  disableOptions();
                });
              },
              key: const Key('A'),
              leading: const Text(
                'A.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              title: Text(
                widget.items[_qno]['A'],
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              selectedTileColor: _selectedColor,
              //textColor: Colors.blue,
              enabled: !answerWasSelected,
            ),
          ),

          //option B
          Container(
            color: _chosenAnswer == 'B' ? _selectedColor : _bgColor,
            child: ListTile(
              onTap: () {
                setState(() {
                  _selectedColor = Colors.blue;
                  _chosenAnswer = 'B';
                  _writeAnswer(_chosenAnswer);
                  disableOptions();
                });
              },
              key: const Key('B'),
              leading: const Text(
                'B.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              title: Text(
                widget.items[_qno]['B'],
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              enabled: !answerWasSelected,
            ),
          ),

          //option C
          Container(
            color: _chosenAnswer == 'C' ? _selectedColor : _bgColor,
            child: ListTile(
              onTap: () {
                _selectedColor = Colors.blue;
                _chosenAnswer = 'C';
                _writeAnswer(_chosenAnswer);
                disableOptions();
              },
              key: const Key('C'),
              leading: const Text(
                'C.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              title: Text(
                widget.items[_qno]['C'],
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              enabled: !answerWasSelected,
            ),
          ),

          //option D
          Container(
            color: _chosenAnswer == 'D' ? _selectedColor : _bgColor,
            child: ListTile(
              // on tap answer will be submitted
              onTap: () {
                setState(() {
                  _chosenAnswer = 'D';
                  _writeAnswer(_chosenAnswer);
                  _selectedColor = Colors.blue;
                  disableOptions();

                  //print(_chosenAnswer);
                });
              },
              key: const Key('D'),
              leading: const Text(
                'D.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              title: Text(
                widget.items[_qno]['D'],
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              selectedColor: Colors.amber,
              enabled: !answerWasSelected,
            ),
          ),

          // if option E exists
          (widget.items[_qno]['E'] != null)
              ? Container(
                  color: _chosenAnswer == 'E' ? _selectedColor : _bgColor,
                  child: ListTile(
                    // on tap answer will be submitted
                    onTap: () {
                      setState(() {
                        _chosenAnswer = "E";
                        _writeAnswer(_chosenAnswer);
                        _selectedColor = Colors.blue;
                        disableOptions();
                      });
                    },
                    key: const Key('E'),
                    leading: const Text(
                      'E.',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    title: Text(
                      widget.items[_qno]['E'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    enabled: !answerWasSelected,
                  ),
                )
              : Text(""),

          // if option F exists
          (widget.items[_qno]['F'] != null)
              ? Container(
                  color: _chosenAnswer == 'F' ? _selectedColor : _bgColor,
                  child: ListTile(
                    // on tap answer will be submitted
                    onTap: () {
                      setState(() {
                        _chosenAnswer = 'F';
                        _writeAnswer(_chosenAnswer);
                        _selectedColor = Colors.blue;
                        disableOptions();
                      });
                    },
                    key: Key('F'),
                    leading: const Text(
                      'F.',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    title: Text(
                      widget.items[_qno]['F'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
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
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultPage(score: _totalScore)));
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
    // var correctAnswer = widget.items[_qno]['answer'];
    userAnswers[_qno] = value;
    // userAnswers[_qno].add(correctAnswer);
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
}
