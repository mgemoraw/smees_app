import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/api/end_points.dart';

import 'package:smees/home_page.dart';
import 'package:smees/views/answer_option.dart';
import 'package:smees/views/common/appbar.dart';

import 'package:smees/views/common/drawer.dart';
import 'package:smees/views/common/status_card.dart';
import 'package:smees/views/result_page.dart';

import '../models/random_index.dart';

var files = {
  "Automotive Engineering": "AutomotiveEngineering",
  "Industrial Engineering": "IndustrialEngineering",
  "Mechanical Engineering": "MechanicalEngineering",
  "Civil Engineering": "CivilEngineering",
  'Water Resources and Irrigation Engineering': "wrie",
  'Hydraulic and Water Resources Engineering': "hwre",
  "Chemical Engineering": "ChemicalEngineering",
  "Food Engineering": "FoodEngineering",
  "Human Nutrition": "HumanNutrition",
  "Electrical Engineering": "ElectricalEngineering",
  "Computer Engineering": "ComputerEngineering",
  "Computer Science": "ComputerScience",
  "Software Engineering": "SoftwareEngineering",
};

// test class
class TestHome extends StatefulWidget {
  final String department;
  const TestHome({Key? key, required this.department}) : super(key: key);

  @override
  State<TestHome> createState() => _TestHomeState();
}

class _TestHomeState extends State<TestHome> {
  var department;
  int departmentId = 0;
  String? token;
  List _items = [];
  final _controller = TextEditingController();
  double _progress = 0.0;
  String message = "";
  TextEditingController yearController = TextEditingController();
  String pageKey = "home";
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // fetch content from json
  Future<void> readJson(String department) async {
    final String response =
        await rootBundle.loadString("assets/$department/$department.json");
    final data = json.decode(response);

    setState(() {
      _items = data;
    });
  }

  List<DropdownMenuItem<String>> getDepartents() {
    //
    List<DropdownMenuItem<String>> departments = [];
    for (String item in files.keys) {
      var menuItem = DropdownMenuItem(value: files[item], child: Text(item));
      departments.add(menuItem);
    }
    return departments;
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString("smees-user");
    Map<String, dynamic> userData = jsonDecode(jsonString!);

    String departmentName = userData['department'];

    final url = Uri.parse(
        "http://localhost:8000/departments/index?name=$departmentName");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          token = userData['token'];
          departmentId = int.parse(response.body);
          // departmentId = userData['departmentId'];
        });
      } else {
        setState(() {
          message = "Error: somthing bad happend!";
        });
      }
    } catch (e) {
      setState(() {
        message = "Errror: $e";
      });
    }
  }

  Future<void> _downloadData(int departmentId, int year) async {
    final url =
        Uri.parse("$API_BASE_URL/questions/${departmentId}/index?year=$year");
    final response = await http.get(url, headers: {
      "Authentication": "Bearer $token",
      "Content-Type": 'application/x-www-form-urlencoded',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/data_$year.json");
      await file.writeAsString(json.encode(data));
      setState(() {
        _progress = 1.0;
        message = "File Saved to ${directory.path}/data_$year.json";
        // print(response.body);
        print("File Saved to ${directory.path}/data_$year.json");
      });
    } else {
      setState(() {
        message = "Failed to load data, please check your connection!";
      });
      throw Exception("Failed to load data, Please Check your connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftNavigation(),
      appBar: SmeesAppbar(title: "SMEES-App"),
      body: Column(children: [
        // user profile card
        const UserStatusCard(),

        // Choose your field of study section
        const Divider(height: 3, color: Colors.blue),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
              "In this page you can select a maximum of 100 questions and practice with answers shown immediately. All Questions are multiple choice and you will be given 1 minute for 1 Question."),
        ),

        SizedBox(height: 16.0),

        // dropdown option to choose and take quiz
        DropdownButton(
            hint: const Text("Select your department here"),
            value: department,
            items: getDepartents(),
            onChanged: (value) {
              setState(() {
                department = value!;
                readJson(department);
                // print(_items);
              });
            }),
        // const DownloadQuestionsJson(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              child: TextField(
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.analytics),
                      hintText: 'Exam Year')),
            ),
            CircularProgressIndicator(value: _progress),
            ElevatedButton(
                onPressed: () {
                  _downloadData(1, int.parse(yearController.text));
                },
                child: const Icon(Icons.download)),
            const SizedBox(height: 20),
          ],
        ),
        SizedBox(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            SizedBox(
              width: 150,
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(hintText: "Type Number of Questions"),
                onTap: () {
                  setState(() {
                    //
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //readJson();
                int qnos = validateInput(_controller.text);
                List<int> indexes = generateIndexes(_items, qnos);
                var items = [];
                for (int i in indexes) {
                  items.add(_items[i]);
                }

                if (qnos > 0 && _items.isNotEmpty) {
                  // start quiz
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakeQuiz(
                        department: "",
                        items: items,
                      ),
                      // const HomePage(),
                    ),
                  );
                }
              },
              child: const Text("Start Quiz"),
            ),
          ]),
        ),

        SizedBox(height: 20.0),
        Text("$message"),
        //
        // _items.isNotEmpty ? Expanded(
        //     child: ListView.builder(
        //       itemCount: _items.length,
        //       itemBuilder: (context, index){
        //         return Card(
        //             key: ValueKey(_items[index]["qid"]),
        //             margin: const EdgeInsets.all(10),
        //             color: Colors.amber.shade100,
        //             child: ListTile(
        //               leading: Text("${_items[index]['qid']}"),
        //               title: Text(_items[index]['question']),
        //               subtitle: Text("Answer: ${_items[index]['answer']}"),
        //
        //               //subtitle: Text(_items[index]['answer']),
        //
        //             )
        //         );
        //       },
        //     )
        // ): ElevatedButton(
        //   onPressed: () {
        //     readJson();
        //     // print(_items);
        //   },
        //   child: Text("Load Json"),
        // )
      ]),
      bottomNavigationBar: Container(
          height: 60,
          decoration: const BoxDecoration(
            //color: Theme.of(context).primaryColor,
            color: Colors.white12,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                enableFeedback: true,
                tooltip: 'Home',
                onPressed: () {
                  setState(() {
                    pageIndex = 0;
                    pageKey = 'home';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(
                          title: "SMEES-App",
                          department: "",
                        ),
                      ),
                    );
                  });
                },
                icon: const Icon(
                  Icons.home_outlined,
                  color: Colors.black54,
                  size: 35,
                ),
              ),
            ],
          )),
    );
  }

  int validateInput(String value) {
    int qnos = 0;
    try {
      qnos = int.parse(value);
      if (qnos > 25) {
        return 25;
      }
    } catch (e) {
      // catch error
    }
    return qnos;
  }
}

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
              "${_qno + 1}. ${widget.items[_qno]['question']}",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),

          // option A
          AnswerOption(
              value: 'A',
              answerText: widget.items[_qno]['A'],
              enabled: !answerWasSelected,
              answerColor:
                  (_chosenAnswer == 'A') ? _selectedColor! : Colors.white,
              answerTap: () {
                setState(() {
                  _selectedColor = Colors.blue;
                  _chosenAnswer = "A";
                  disableOptions();
                });
              }),

          // option B
          AnswerOption(
              value: 'B',
              answerText: widget.items[_qno]['B'],
              enabled: !answerWasSelected,
              answerColor:
                  (_chosenAnswer == 'B') ? _selectedColor! : Colors.white,
              answerTap: () {
                setState(() {
                  _selectedColor = Colors.blue;
                  _chosenAnswer = "B";
                  disableOptions();
                });
              }),

          AnswerOption(
              value: 'C',
              answerText: widget.items[_qno]['C'],
              enabled: !answerWasSelected,
              answerColor:
                  (_chosenAnswer == 'C') ? _selectedColor! : Colors.white,
              answerTap: () {
                _selectedColor = Colors.blue;
                _chosenAnswer = "C";
                disableOptions();
              }),

          // option D
          AnswerOption(
              value: 'D',
              answerText: widget.items[_qno]['D'],
              answerColor:
                  (_chosenAnswer == 'D') ? _selectedColor! : Colors.white,
              enabled: !answerWasSelected,
              answerTap: () {
                setState(() {
                  _selectedColor = Colors.blue;
                  _chosenAnswer = "D";
                  disableOptions();
                });
              }),

          // if option E exists
          (widget.items[_qno]['E'] != null)
              ? Container(
                  color: _chosenAnswer == 'E' ? _selectedColor : Colors.white12,
                  child: ListTile(
                    // on tap answer will be submitted
                    onTap: () {
                      setState(() {
                        _chosenAnswer = "E";
                        disableOptions();
                      });
                    },
                    key: Key('E'),
                    leading: Text(
                      'E.',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    title: Text(
                      widget.items[_qno]['E'],
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    enabled: !answerWasSelected,
                  ),
                )
              : Text(""),

          // if option F exists
          (widget.items[_qno]['F'] != null)
              ? Container(
                  color: _chosenAnswer == 'F' ? _selectedColor : Colors.white12,
                  child: ListTile(
                    // on tap answer will be submitted
                    onTap: () {
                      setState(() {
                        _chosenAnswer = 'F';
                        disableOptions();
                      });
                    },
                    key: Key('F'),
                    leading: Text(
                      'F.',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    title: Text(
                      widget.items[_qno]['F'],
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
        //_qno--;
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
