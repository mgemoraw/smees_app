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
import 'package:smees/views/common/spinner_loader.dart';
import 'package:smees/views/common/status_card.dart';
import 'package:smees/views/result_page.dart';
import 'package:smees/views/take_quiz.dart';
import 'package:smees/views/user_provider.dart';

import '../models/random_index.dart';
import 'common/circular_loading_indicator.dart';

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
  late bool isLoading = false;
  late bool isLoaded = false;
  String? _error;


  // filtering parameters
  int? selectedModule;
  int? selectedYear;
  int? numberOfQuestions = 0;



  @override
  void initState() {
    super.initState();
    _loadUserData();
    final useModeProvider = Provider.of<UseModeProvider>(context, listen:
    false);
    readModules(useModeProvider);
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

    // set loading state
    setState(() {
      isLoading = true;
      _error=null;
    });

    try {
      if (faculty != null) {
        final String response =
        await rootBundle.loadString("assets/$faculty/$department/questions"
            ".json");
        final data = json.decode(response);

        setState(() {
          _items = data;
          _error = "";
          if (_items.length > 0){
            _progress = 1.0;
            isLoaded = true;
          }
        });
      } else {
        //
        // debugPrint(faculty);
        // debugPrint("Items not found");
        setState(() {
          message = "Error: Items not found!";
          _error = "Error: Items not found!";
        });
      }
    } catch(err) {
      debugPrint("Error: ${err.toString()}");
      setState(() {
        message = "Error: $err";
        _error = "$err";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }

  }

  // fetch content from json
  Future <List<dynamic>> readModules(UseModeProvider useMode) async {
    await _loadUserData();
    String department = user.department!;
    String? faculty = _getFaculty(department.toLowerCase());
    department = department.toLowerCase().replaceAll(" ", "_");

    debugPrint("....loading modules");

    if (useMode.offlineMode) {
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
    } else {
      try {
        final response = await http.get(Uri.parse
          ('$API_BASE_URL/modules/index'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _modules = json.decode(response.body);
          });
          return data;
        } else {
          debugPrint("Items not found");
          return [];
        }
      } catch (err) {
        //
        debugPrint("Network Error: $err");
        return [];
      }
    }
  }

  List <dynamic> filterByYear(int? year) {

    if (year == 0 || year == null) {
      return _items;
    }
    late List<dynamic> newItems = [];

    for (int i = 0; i < _items.length; i++){
      if (_items[i]['year']==year){
        newItems.add(_items[i]);
      }
    }
    return newItems;
  }
  List<dynamic> filterByModule(int? moduleId) {
    // filters questions by Module
    late List<dynamic> filteredItems = [];

    if (selectedModule == 0 || selectedModule == null){
      debugPrint("Filter by Module exempted! You selected all ");
      return _items;
    }

    for(var item in _items){
      if (item['exam_module_id'] == null) {
        debugPrint("Can't filter by module, because I found null value");
        return _items;
      } else if (item['exam_module_id'] != null && item['exam_module_id'] ==
          selectedModule){
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
    List<DropdownMenuItem> modules = [
      DropdownMenuItem(value: 0, child: Text("All")),
    ];

    for (var module in _modules) {
      var menuItem = DropdownMenuItem(
        value: module['id'],
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

      // set loading state
      setState(() {
        isLoading = true;
        isLoaded = false;
        _error = null;
      });

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // final directory = await getApplicationDocumentsDirectory();
        // final file = File("${directory.path}/data_$year.json");
        // await file.writeAsString(json.encode(data));
        setState(() {

          _data = data;
          _items = data;
          message = "data saved to ";

          return;
        });if (_items.length > 0){
          _progress = 1.0;
          isLoaded = true;
        }
      } else {
        setState(() {
          message = "Error: ${response.body}";
          _error = response.body;
        });
      }
    } catch (err) {
      // message = "Error: $err}";
      setState(() {
        message = "Error: $err}";
        _error = "Error: Please check your network connection!";
      });
    } finally {
      // set loading state
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final useModeProvider = Provider.of<UseModeProvider>(context);
    // final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      drawer: const LeftNavigation(),
      appBar: SmeesAppbar(title: "SMEES-App"),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          // user profile card
          const UserStatusCard(),

          // Choose your field of study section
          const Divider(height: 3, color: Colors.blue),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
                "This feature of the app enables you to load questions from "
                    "either of online source or offline source, apply filters"
                    " on questions by module name and year and practice as "
                    "many as you can.",
                style: TextStyle(fontSize: 15)),
          ),

          // const SizedBox(height: 16.0),

          // dropdown option to choose and take quiz
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              spacing: 10,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                        String? department = user.department;
                        if (department != null) {
                          // if user is offline it reads from the json file
                          // in the assets
                          if (useModeProvider.offlineMode) {
                            // fetch offline data when offline
                            readJson(department!);

                          } else {
                            // downloads data from online store
                            String deptSlug = user.department!.toLowerCase()
                                .replaceAll(' ','-');
                            _downloadData(deptSlug, 2022);
                            // print("departmentId: $departmentId items: $_items");
                          }
                        } else {
                          // else set error message
                          setState(() {
                            _error = "Error: Your department is null";
                          });
                        }
                    },
                    child: isLoading ? CircularProgressIndicator
                      (color:Colors.blue) : Text
                      ("Load "
                      "Questions", style: TextStyle(color: Colors
                        .blueAccent, fontSize: 15),
                    ),
                  ),
                ),


                // sets loading when loading and green bar when loading complete
                // isLoaded ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _progress > 0 ? Stack(
                      alignment: Alignment.center,
                      children:[

                        LinearProgressIndicator(
                          value: _progress,
                          color: Colors.green,
                          minHeight: 2,
                        ),
                        Text(
                          "${(_progress * 100).toStringAsFixed(0)}%",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ]
                  ) : Text(""),
                ),


                ExpansionTile(
                  leading: Icon(Icons.filter_list),
                  title: Text(
                  "Filter Questions",
                  style: TextStyle(color: Colors
                      .blueAccent, fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),

                  subtitle: Text("Filter questions by exit exam module, and "
                      "exam year"),
                  enabled: isLoaded,
                  children: [
                    DropdownButtonFormField(
                      hint: Text("Select Module", style:TextStyle
                        (color: Colors.blueAccent)),
                      value: selectedModule,
                      items: getModules(),
                      onChanged: (value){
                        // call filter by module
                        filterByModule(value);
                      },
                      style: TextStyle(color:Colors.blueAccent),
                      decoration: InputDecoration(
                        labelText: "Filter by Exit Exam Module",
                        fillColor: Colors.white12,
                        filled: true,
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.blueAccent),
                      ),
                    ),

                    DropdownButtonFormField(
                      hint: Text("Select Year", style:TextStyle
                        (color: Colors.blueAccent)),
                      value: selectedYear,
                      items: [
                        DropdownMenuItem(value: 0, child: Text('All')),
                        DropdownMenuItem(value:2024, child: Text('2024')),
                        DropdownMenuItem( value:2025, child: Text('2025')),
                      ],
                      onChanged: (value){
                        // call filter by module
                        filterByYear(value);
                      },
                      decoration: InputDecoration(
                        labelText: "Filter by Exit Exam Year",
                        fillColor: Colors.white12,
                        filled: true,
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        // labelStyle: TextStyle(color: Colors.blueAccent),
                      ),
                      style: TextStyle(color:Colors.blueAccent),
                    ),

                    // query by number of questions and start reading
                    TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      style:TextStyle(color:Colors.blueAccent),
                      decoration:
                      const InputDecoration(
                        labelText: "Number of questions",
                        hintText: "Type Number",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.blueAccent),
                      ),
                      onChanged: (value) {
                        setState(() {
                          // numberOfQuestions = value!;
                        });
                      },
                    ),
                  ],
                ),


                // DropdownButton(
                //   isExpanded: true,
                //     hint: const Text("Filter By Exit Exam Module"),
                //     value: examModule,
                //     items: getModules(),
                //     onChanged: (value) {
                //       filterByModule(value);
                //     }),

                // // filter by year of exam
                // DropdownButton(
                //     isExpanded: true,
                //     hint: const Text("Filter by Exam Year"),
                //     value: examYear,
                //     items:[
                //       DropdownMenuItem(child: Text('All'), value:0),
                //       DropdownMenuItem(child: Text('2024'), value:2024),
                //       DropdownMenuItem(child: Text('2025'), value:2025),
                //     ],
                //     onChanged: (value) {
                //       //
                //       if (value != null){
                //         setState(() {
                //           examYear = value;
                //           _items = filterByYear(value);
                //         });
                //       }else {
                //         setState(() {
                //           examYear = 0;
                //         });
                //       }
                //     }
                // ),

                // // query by number of questions and start reading
                // TextFormField(
                //   controller: _controller,
                //   keyboardType: TextInputType.number,
                //   decoration:
                //   const InputDecoration(hintText: "Type Number of Questions"),
                //   onChanged: (value) {
                //     setState(() {
                //       //
                //       String? department = user.department;
                //       if (department != null) {
                //         if (useModeProvider.offlineMode) {
                //           // fetch offline data when offline
                //           readJson(user.department!);
                //
                //         } else {
                //           // download data when online
                //           String deptSlug = user.department!.toLowerCase()
                //               .replaceAll(' ','-');
                //           _downloadData(deptSlug, 2022);
                //
                //           // print("departmentId: $deptSlug items: $_items");
                //         }
                //       } else {
                //         // print("Department: $department");
                //       }
                //
                //     });
                //   },
                // ),

                // start quiz button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoaded ? startQuiz : null,
                    child: const Text("Start Quiz", style: TextStyle
                      (fontSize: 15, color: Colors.blueAccent)),
                  ),
                ),

              ],
            ),
          ),

          // display error message
          (_error == null || _error == '') ?
          _items.length > 0 ? Text("Available Questions: "
              "${_items.length}") : Text("No Contents Found")
              :
              Text("$_error"),
        ]),
      ),

      // bottom navigation bar showing hom buttonn
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
                  color: Colors.greenAccent,
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
      if (qnos >= _items.length) {
        return _items.length;
      }
    } catch (e) {
      // catch error
    }
    return qnos;
  }

  void startQuiz() {

      try {
        //
        int qnos = validateInput(_controller.text);
        if (qnos == 0){
          qnos = _items.length;
        }
        List<int> indexes = generateIndexes(_items, qnos);
        var items = [];

        for (int i in indexes) {
          // items.add(_items[i]);
          items.add(_items[i]);
        }

        if (_items.isNotEmpty) {
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
  }

  // end of class
}
