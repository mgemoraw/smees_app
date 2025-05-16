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

Map<String, List<String>> faculties = {
  'fcwre': ['civil engineering', 'hydraulic and water resources engineering',
    'irrigation and water resources engineering'],
  'fmie': ['mechanical engineering', 'industrial engineering', 'automotive '
      'engineering', 'material science'],
  'fc': ['computer science', 'software engineering', 'information '
      'technology', 'information science', 'cyber security'],
  'fece': ['electrical engineering', 'computer engineering'],
  'fcfe': ['food engineering', 'chemical engineering', 'human nutrition'],
};

var files = {
  "Automotive Engineering": "fmie/automotive_engineering",
  "Industrial Engineering": "fmie/Industrial Engineering",
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
  var examModule;
  String? departmentName;
  int departmentId = 0;
  List _data = [];
  String? token;
  List _items = [];
  late List<dynamic> _modules =[];
  final _controller = TextEditingController();
  double _progress = 0.0;
  String message = "";
  TextEditingController yearController = TextEditingController();
  String pageKey = "home";
  int pageIndex = 0;
  late User user;
  late int examYear = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    readModules();
    // _modules = readModules();
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

  String? _getFaculty(String department){
    ///this function returns the faculty name of department

      for (var entry in faculties.entries) {

        ///debugPrint("deparments under this faculty");
        /// for (var dep in entry.value){
        /// this prints list of departments in the faculty
        ///  print("department
        /// }

        if (entry.value.contains(department.toLowerCase())){
          // return parent key for faculty short name
          return entry.key;
        }
      }
    return null;
  }
  // fetch content from json
  Future<void> readJson(String department) async {
    String? faculty = _getFaculty(department.toLowerCase());
    department = department.toLowerCase().replaceAll(" ", "_");

    try {
      if (faculty != null) {
        final String response =
        await rootBundle.loadString("assets/$faculty/$department/questions"
            ".json");
        final data = json.decode(response);

        setState(() {
          _items = data;
        });
      } else {
        //
        debugPrint(faculty);
        debugPrint("Items not found");
      }
    } catch(err) {
      debugPrint("Error: ${err.toString()}");
    }

  }

  // fetch content from json
  Future <List<dynamic>> readModules() async {
    await _loadUserData();
    String department = user.department!;
    String? faculty = _getFaculty(department.toLowerCase());
    department = department.toLowerCase().replaceAll(" ", "_");

    debugPrint("....loading modules");
    try {
      if (faculty != null) {
        final response =
        await rootBundle.loadString("assets/$faculty/$department/exam_modules"
            ".json");
        final data = json.decode(response);
        setState(() {
          _modules = json.decode(response);
        });
        return data;
      } else {
        //
        // debugPrint(faculty);
        debugPrint("Items not found");
        return [];
      }
    } catch(err) {
      debugPrint("Error: ${err.toString()}");
      return [];
    }

  }

  List <dynamic> filterByYear(int year) {

    if (year == 0) {
      return _items;
    }
    late List<dynamic> new_items = [];

    for (int i = 0; i < _items.length; i++){
      if (_items[i]['year']==year){
        new_items.add(_items[i]);
      }
    }
    return new_items;
  }
  List<dynamic> filterByModule(String moduleName) {
    // filters questions by Module
    late List<dynamic> filteredItems = [];

    if (moduleName == 'all'){
      debugPrint("Filter exempted! you selected $moduleName");
      return _items;
    }

    for(var item in _items){
      if (item['exam_module'] == null) {

        debugPrint("Can't filter by module, because I found null value");
        return _items;
      } else if (item['exam_module'] != null && item['exam_module'] ==
          moduleName){
        filteredItems.add(item);
      }
    }
    // return filtered questions
    // print(filteredItems);

    return filteredItems;
  }

  void filterByCourseName(String courseName){
    // filters questions by course name/code
    final filteredItems;
    for(var item in _items){
      // if (item['course_name'] != null && item['course'].toLowerCase() ==
      //     courseName){
      //   print('course name: ${item[course]}');
      // }
      print(item['course_name']);
    }
  }


  List<DropdownMenuItem<String>> getDepartments() {
    //
    List<DropdownMenuItem<String>> departments = [];
    for (String item in files.keys) {
      var menuItem = DropdownMenuItem(value: files[item], child: Text(item));
      departments.add(menuItem);
    }
    return departments;
  }

  List<DropdownMenuItem> getModules() {
    List<DropdownMenuItem> modules = [];
    modules.add(DropdownMenuItem(value: 'all', child: Text("All")));
    for (var module in _modules) {
      var menuItem = DropdownMenuItem(
          value: module['name'],
          child:Text(module['name']),
      );

      modules.add(menuItem);
    }
    return modules;
  }


  Future<void> _downloadData(String depName, int year) async {
    final url =
        Uri.parse("$API_BASE_URL/questions/index/$depName?year=$year");
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

        // dropdown option to choose and take quiz
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DropdownButton(

                hint: const Text("Filter By Exit Exam Module"),
                value: examModule,
                items: getModules(),
                onChanged: (value) {
                  setState(() {
                    examModule = value!;
                    String? department = user.department;
                    if (department != null) {
                      if (useModeProvider.offlineMode) {
                        // fetch offline data when offline
                        readJson(department!);

                        // filter by Module
                        setState(() {
                          _items = filterByModule(value);
                        });


                      } else {
                        // download data when online
                        String deptSlug = user.department!.toLowerCase()
                            .replaceAll(' ','-');
                        _downloadData(deptSlug, 2022);
                        // print("departmentId: $departmentId items: $_items");
                      }
                    } else {
                      // print("Department: $department");
                    }
                    // _downloadData(departmentId, int.parse(yearController.text));
                    // print(_items);
                  });
                }),
          ),

        SizedBox(
          child: DropdownButton(
            hint: const Text("Filter by Exam Year"),
            value: examYear,
            items:[
              DropdownMenuItem(child: Text('All'), value:0),
              DropdownMenuItem(child: Text('2024'), value:2024),
              DropdownMenuItem(child: Text('2025'), value:2025),
            ],
              onChanged: (value) {
                //
                if (value != null){
                  setState(() {
                    examYear = value;
                    // _items = filterByYear(value);
                  });
                }else {
                  setState(() {
                    examYear = 0;
                  });
                }
              }
          ),

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
                onChanged: (value) {
                  setState(() {
                    //
                    String? department = user.department;
                    if (department != null) {
                      if (useModeProvider.offlineMode) {
                        // fetch offline data when offline
                        readJson(user.department!);

                      } else {
                        // download data when online
                        String deptSlug = user.department!.toLowerCase()
                            .replaceAll(' ','-');
                        _downloadData(deptSlug, 2022);

                        // print("departmentId: $deptSlug items: $_items");
                      }
                    } else {
                      // print("Department: $department");
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
                          content: Text("Error: No Items found!"),
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
        SingleChildScrollView(child: Text("Total Available Questions: "
            "${_items.length}")),
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
                    Navigator.pushReplacementNamed(context, "/");
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const Home(
                    //       title: "SMEES-App",
                    //       department: "",
                    //     ),
                    //   ),
                    // );
                  });
                },
                icon: const Icon(
                  Icons.home_outlined,
                  color: Colors.black54,
                  size: 35,
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     setState(() {
              //       // Navigator.pushReplacementNamed(context, "/stats");
              //     });
              //   },
              //   icon: const Icon(Icons.bar_chart),
              // ),
              // IconButton(
              //   onPressed: () {
              //     setState(() {
              //       // Navigator.pushNamed(context, "/profile");
              //     });
              //   },
              //   icon: const Icon(Icons.group),
              // ),
            ],
          )),
    );
  }

  int validateInput(String value) {
    int qnos = 0;
    try {
      qnos = int.parse(value);
      if (qnos > _items.length) {
        return _items.length;
      }
    } catch (e) {
      // catch error
    }
    return qnos;
  }
}
