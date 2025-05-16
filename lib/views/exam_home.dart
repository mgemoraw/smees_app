import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smees/home.dart';
import 'package:smees/home_page.dart';
import 'package:smees/user_profile.dart';
import 'package:smees/student_statistics.dart';
import 'package:smees/views/answer_option.dart';
import 'package:smees/views/common/appbar.dart';
import 'package:smees/views/common/drawer.dart';
import 'package:smees/views/common/status_card.dart';
import 'package:smees/views/learn_zone.dart';
import 'package:smees/views/take_exam.dart';
import 'package:smees/views/user_provider.dart';

import '../api/end_points.dart';
import '../constants/faculties.dart';
import '../models/random_index.dart';
import '../models/smees_test.dart';
import '../models/test_model.dart';
import '../models/user.dart';

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
class ExamHome extends StatefulWidget {
  final String department;
  // const ExamHome({Key? key, required this.department});
  const ExamHome({super.key, required this.department});

  @override
  State<ExamHome> createState() => _ExamHomeState();
}

class _ExamHomeState extends State<ExamHome> {
  // list of pages in the bottom appbar
  final pages = {
    'home': const HomePage(department: "", username: ""),
    'exam': const LearnZone(department: ""),
    'userstat': const Statistics(),
    'profile': const UserProfile(),
    // 'learn': const LearnZone(),
  };
  List _items = [];
  late List<dynamic> _modules =[];
  String? _department;
  String pageKey = "home";
  int pageIndex = 0;
  late String? _message = "";
  bool isLoading = false;
  int examId = 0;
  String message = "";
  String? token;
  late TestSchema examData;

  late User user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
          examData = TestSchema(
            id: 0,
            userId: user.username!,
            startedAt: DateTime.now(),
            completedAt: DateTime.now(),
            totalQuestions: _items.length,
            score: 0,
            correctAnswers: 0,
            responses: [],
            departmentId: 0,
          );


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

  // automatically downloads exam questions when online
  Future <void> _downloadQuestions() async {

    // final preferences = await SharedPreferences.getInstance();
    // final userData =  preferences.getString('smeesUser');
    // int departmentId = jsonDecode(userData!)['departmentId'];
    // String deptName = jsonDecode(userData!)['department'].toLowerCase();


    // load user data if not loaded
    await _loadUserData();


    String deptName = user.department!;
    String deptSlug = deptName.toLowerCase().replaceAll(' ', '-');
    debugPrint("Department-Slug: $deptSlug");

    // final year = year;
    final url = Uri.parse("$API_BASE_URL${testStartApi}/${deptSlug}?limit=100");

    final storage =  FlutterSecureStorage();
    final token = await storage.read(key: 'smees-token');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    // final body = {};

    // debugPrint(headers.toString());

    try {
       final response = await http.get(
         url,
         headers: headers,
       );

       if (response.statusCode == 200) {
         final data = json.decode(response.body);
         // final directory = await getApplicationDocumentsDirectory();
         // final file = File("${directory.path}/data_$year.json");
         // await file.writeAsString(json.encode(data));
         
         // final stringData = response.body;

         setState(() {
           // _progress = 1.0;
           // _items = data;

           // examId = data['test_id'];
           final test = jsonEncode(data['test']);
           debugPrint(test);


           // debugPrint("id ${test['id']}");

           // final examData = TestSchema.fromJson(jsonDecode(test));
             examData = TestSchema(
               id: 0,
               userId: user.username!,
               startedAt: DateTime.now(),
               completedAt: DateTime.now(),
               totalQuestions: _items.length,
               score: 0,
               correctAnswers: 0,
               responses: [],
               departmentId: 0,
             );

           _items = data['questions'];
           message = "success";

           return;
         });
       } else {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text("Error ${response.statusCode}: ${response.body}"),
             backgroundColor: Colors.redAccent,
           ),
         );
       }
    } catch(err) {
      //
      debugPrint(err.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Downloading Questions Failed: ${err.toString()
          }"),
          backgroundColor: Colors.redAccent,
        ),
      );

    } finally {
      setState(() {
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    final useModeProvider = Provider.of<UseModeProvider>(context);
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      drawer: LeftNavigation(),
      appBar: SmeesAppbar(title: "SMEES"),
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
                "Welcome to your Model Exit Exam Page You will be given 100 questions with 1 minute for each question. You cannot exit from the model exam once started. If you stopped the exam in any case the questions you answered up to the stoppage time will be recorded. Once you completed your answers, do not forget to submit your answers to get the final score. If your exam is interrupted, the number of questions you answered will be stored for the allowed exam period only.  You can't submit incomplete questions as the submit button is disabled unless all the questions are checked. Your performance will be sent to Your University's Quality Assurance Office when You are connected to internet. Good Luck and Enjoy"),
          ),

          // dropdown option to choose and take Exam
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // DropdownButton(
                  //   value: department,
                  //   hint: const Text("Selct your Field of Study Here"),
                  //   items: getDepartents(),
                  //   onChanged: (value) {
                  //     //
                  //     setState(() {
                  //       department = value;
                  //       readJson(department);
                  //     });
                  //   },
                  // ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                // set loading
                setState(() {
                  isLoading = true;
                });
                if (useModeProvider.offlineMode) {
                  if (user.department != null){
                    await readJson(user.department!);
                  }
                } else if(!useModeProvider.offlineMode) {
                  await _downloadQuestions();
                }

                int qnos = (_items.length >= 100) ? 100 : _items.length;

                List<int> indexes = [];
                var items = [];

                if (_items.length > 100) {
                  indexes = generateIndexes(_items, qnos);
                  for (int i in indexes) {
                    items.add(_items[i]);
                  }
                } else {
                  items = _items;
                }

                if (qnos > 0 && _items.isNotEmpty) {
                  // start quiz

                  // Navigator.pushNamed(context, "/exam");
                  Navigator.pop(context); // pop the exam page first
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TakeExam(
                        department: user.department!,
                        items: items,
                        examData: examData,
                      ),
                    ),
                  );
                } else {
                  _message!.isNotEmpty ? ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                        content: Text("Error: $_message"),
                      backgroundColor: Colors.redAccent,
                    ),
                  ): null ;
                }
              },
              child:
                  isLoading ? CircularProgressIndicator() : Text("Start Exam"),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: Container(
          height: 60,
          decoration: const BoxDecoration(
            // color: Theme.of(context).secondaryHeaderColor,
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
                  pageIndex = 0;
                  pageKey = 'home';

                  /* go back to home */
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/");
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const Home(
                  //       title: "BiT-ExitE",
                  //       department: "",
                  //     ),
                  //   ),
                  // );
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
