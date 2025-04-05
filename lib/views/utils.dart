

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/end_points.dart';
import '../models/user.dart';

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
Future<List?> readJson(String department) async {
  String? faculty = _getFaculty(department.toLowerCase());
  department = department.toLowerCase().replaceAll(" ", "_");

  try {
    if (faculty != null) {
      final String response =
      await rootBundle.loadString("assets/$faculty/$department/human_nutrition.json");
      final data = json.decode(response);

      return data;

    } else {
      //
      debugPrint(faculty);
      debugPrint("Items not found");
      return null;
    }
  } catch(err) {
    debugPrint("Error: ${err.toString()}");
    return null;
  }
  return null;
}

Future<Map<String, dynamic>?> _loadUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString("smees-user");
  final userData = jsonDecode(jsonString!);

  return userData;

    // departmentId = userData['departmentId'];
    final token = userData['token'];
    final user = User(
      username: userData['username'] ,
      password: userData['token'],
      email: userData['email'],
      university: userData['university'],
      department: userData['department'],
    );
}

// fetch content from json
Future <List<dynamic>> readModules() async {
  final userData = await _loadUserData();
  String department = userData!['department'];
  String? faculty = _getFaculty(department.toLowerCase());
  department = department.toLowerCase().replaceAll(" ", "_");

  debugPrint("....loading modules");
  try {
    if (faculty != null) {
      final response =
      await rootBundle.loadString("assets/$faculty/$department/exam_modules"
          ".json");
      final data = json.decode(response);
      // setState(() {
      //   _modules = json.decode(response);
      // });
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


List<dynamic> filterByModule(List<dynamic> items, String moduleName) {
  // filters questions by Module
  late List<dynamic> filteredItems = [];

  if (moduleName == 'all'){
    debugPrint("Filter exempted! you selected $moduleName");
    return items;
  }

  for(var item in items){
    if (item['exam_module'] == null) {

      debugPrint("Can't filter by module, because I found null value");
      return items;
    } else if (item['exam_module'] != null && item['exam_module'] ==
        moduleName){
      filteredItems.add(item);
    }
  }
  // return filtered questions
  // print(filteredItems);

  return filteredItems;
}

void filterByCourseName(List<dynamic> items, String courseName){
  // filters questions by course name/code
  final filteredItems;
  for(var item in items){
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

Future <List<DropdownMenuItem>> getModules() async {
  final List<dynamic> mods = await readModules();
  List<DropdownMenuItem> modules = [];
  modules.add(DropdownMenuItem(value: 'all', child: Text("All")));
  for (var module in mods) {
    var menuItem = DropdownMenuItem(
      value: module['name'],
      child:Text(module['name']),
    );

    modules.add(menuItem);
  }
  return modules;
}


Future<Map<String, dynamic>?> _downloadData(String deptName, int year) async {
  final url =
  Uri.parse("$API_BASE_URL/questions/index/$deptName?year=$year");
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // final directory = await getApplicationDocumentsDirectory();
      // final file = File("${directory.path}/data_$year.json");
      // await file.writeAsString(json.encode(data));

      return data;
      // setState(() {
      //   _progress = 1.0;
      //   _data = data;
      //   _items = data;
      //   message = "data saved to ";
      //
      //   return;
      // });
    } else {
      debugPrint("Failed to load data, please check your internet connection!");
      return null;
      // setState(() {
      //   message = "Failed to load data, please check your connection!";
      // });
    }
  } catch (err) {
    debugPrint("Error: $err");
    // message = "Error: $err}";
    return null;
  }
}