import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/api/end_points.dart';

import 'package:smees/home_page.dart';
import 'package:smees/models/user.dart';
import 'package:smees/views/answer_option.dart';
import 'package:smees/views/common/appbar.dart';

import 'package:smees/views/common/drawer.dart';
import 'package:smees/views/common/status_card.dart';
import 'package:smees/views/result_page.dart';
import 'package:smees/views/take_quiz.dart';
import 'package:smees/views/user_provider.dart';

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
  // var department;
  String? departmentName;
  int departmentId = 0;
  List _data = [];
  String? token;
  List _items = [];
  final _controller = TextEditingController();
  double _progress = 0.0;
  String message = "";
  TextEditingController yearController = TextEditingController();
  String pageKey = "home";
  int pageIndex = 0;
  late User user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // readJson();
  }

  // fetch content from json
  Future<void> readJson(String department) async {
    department = department.replaceAll(" ", "");
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
    final userData = jsonDecode(jsonString!);

    setState(() {
      // departmentId = userData['departmentId'];
      token = userData['token'];
      user = User(
        username: userData['username'] ,
        password: userData['token'],
        email: userData['email'],
        university: userData['university'],
        department: userData['department'],
      );
    });
    ;
  }

  Future<void> _downloadData(int departmentId, int year) async {
    final url =
        Uri.parse("$API_BASE_URL/questions/$departmentId/index?year=$year");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // final directory = await getApplicationDocumentsDirectory();
        // final file = File("${directory.path}/data_$year.json");
        // await file.writeAsString(json.encode(data));
        setState(() {
          _progress = 1.0;
          _data = data;
          _items = data;
          message = "data saved to ";

          return;
        });
      } else {
        setState(() {
          message = "Failed to load data, please check your connection!";
        });
      }
    } catch (err) {
      message = "Error: $err}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final useModeProvider = Provider.of<UseModeProvider>(context);
    // final userProvider = Provider.of<UserProvider>(context);

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
              "In this page you can select a maximum of 100 questions and practice with answers shown immediately. All Questions are multiple choice and you will be given 1 minute for 1 Question. Enjoy!",
              style: TextStyle(fontSize: 15)),
        ),

        // const SizedBox(height: 16.0),

        // if offline mode is true, load questions from offline data source
        // useModeProvider.offlineMode
        !context.watch<UseModeProvider>().offlineMode
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //   width: 250,
                      //   child: TextField(
                      //       controller: yearController,
                      //       keyboardType: TextInputType.number,
                      //       style: const TextStyle(
                      //           fontSize: 15, color: Colors.black),
                      //       decoration: const InputDecoration(
                      //           prefixIcon: Icon(Icons.analytics),
                      //           hintText: 'Exam Year')),
                      // ),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       setState(() async {
                      //         await _downloadData(
                      //             departmentId, int.parse(yearController.text));
                      //         // print(message);
                      //       });
                      //     },
                      //     child: const Icon(Icons.download)),
                      // const SizedBox(height: 20),
                    ],
                  ),
                  LinearProgressIndicator(
                    value: _progress,
                    color: Colors.green,
                    minHeight: 10,
                  ),
                ],
              )
            : Text(""),
        // // dropdown option to choose and take quiz
        // SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: DropdownButton(
        //         hint: const Text("Select your department here"),
        //         value: department,
        //         items: getDepartents(),
        //         onChanged: (value) {
        //           setState(() {
        //             department = value!;

        //             // department = context.watch<UserProvider>().user!.department;

        //             readJson(department);
        //             // _downloadData(departmentId, int.parse(yearController.text));
        //             // print(_items);
        //           });
        //         }),
        //   ),

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
                onChanged: (value) {
                  setState(() {
                    //
                    String? department = user.department;
                    if (department != null) {
                      if (useModeProvider.offlineMode) {
                        // fetch offline data when offline
                        readJson(files[department]!);
                      } else {
                        // download data when online
                        _downloadData(departmentId, 2022);
                        print(_items);
                      }
                    } else {
                      print("Department: $department");
                    }

                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  //
                  int qnos = validateInput(_controller.text);
                  List<int> indexes = generateIndexes(_items, qnos);
                  var items = [];

                  for (int i in indexes) {
                    // items.add(_items[i]);
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
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showMaterialBanner(
                      MaterialBanner(
                          content: Text("Error: No content found!"),
                          actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentMaterialBanner();
                            },
                            child: Icon(Icons.close)),
                      ]));
                }
              },
              child: const Text("Start Quiz"),
            ),
          ]),
        ),

        const SizedBox(height: 20.0),
        SingleChildScrollView(child: Text("Data: ${_items.length}")),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              IconButton(
                onPressed: () {
                  setState(() {
                    // Navigator.pushNamed(context, "/stats");
                  });
                },
                icon: const Icon(Icons.bar_chart),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    // Navigator.pushNamed(context, "/profile");
                  });
                },
                icon: const Icon(Icons.group),
              ),
            ],
          )),
    );
  }

  int validateInput(String value) {
    int qnos = 0;
    try {
      qnos = int.parse(value);
      if (qnos > 50) {
        return 50;
      }
    } catch (e) {
      // catch error
    }
    return qnos;
  }
}
