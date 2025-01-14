import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smees/api/end_points.dart';

import 'package:smees/models/department.dart';
import 'package:smees/models/user.dart';

var apiUrl = dotenv.env["API_BASE_URL"];
// var apiKey = dotenv.env['API_KEY'];

Future<Map<String, dynamic>> getLoggedUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString('smees-user');
  if (jsonString != null) {
    Map<String, dynamic> userData = jsonDecode(jsonString);
    return userData;
  }
  return {};
}

Future getAllDepartments({int limit = 0}) async {
  final url = Uri.parse("$apiUrl/$getDepartmentsApi?$limit");
  var message = "";
  try {
    var response = await http.get(url);
    message = "data: ${response.body}";
    var deps = [];
    for (var d in jsonDecode(response.body)) {
      deps.add(DepartmentModel(name: d['name'], description: d['description']));
    }

    return message;
    // return deps;
  } catch (e) {
    message = "Error: $e";
  }

  print(message);
  return message;
}

Future<Map<String, dynamic>> loadUserData() async {
  // get user department
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString("smees-user");

  if (jsonString != null) {
    Map<String, dynamic> userData = jsonDecode(jsonString!);
    return userData;
  }
  return {};
}

Future fetchQuizQuestions({int year = 2024, int limit = 100}) async {
  // get user department
  final userData = await loadUserData();
  int departmentId = userData['departmentId'];
  if (userData.isEmpty) {
    return [];
  }
  final url = Uri.parse("$apiUrl/questions$departmentId/index?$limit");
  Map<String, String> headers = {
    'Authorization': "Bearer ${userData['token']}",
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  try {
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (err) {
    return {"Error": err};
  }
}

Future fetchUsers() async {
  final url = Uri.parse("$apiUrl/$usersGetAllApi");

  var response = await http.get(url);
  var users = [];
  for (var u in jsonDecode(response.body)) {
    // users.add(User(u['id'], u['name'], u['email'], u['password']));
  }
  print(response.body);
  // print("users: $users");
  return users;
}

Future downloadAndSaveFile(int departmentId, int year) async {
  late String message = '';
  final url =
      Uri.parse("$API_BASE_URL/questions/$departmentId/index?year=$year");
  final userData = await getLoggedUserData();
  String? token = userData['token'];

  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  // check and request storage permission
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
    if (!status.isGranted) {
      message = "Storage permission is not granted";
    }
  }
  try {
    // get the approprieate directory
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) {
      return;
    }

    // create teh subderectory if it doesn't exist
    final subDirectory = Directory('${directory.path}/smees');
    if (!await subDirectory.exists()) {
      await subDirectory.create(recursive: true);
      message = "Working folder ${subDirectory.path} created";
    } else {
      message = "Working folder ${subDirectory.path} exists";
    }
    // fetch data
    final response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      // save file to subdirectory
      final file =
          File("$subDirectory.path/${departmentId}_data_.${year}.json");
      await file.writeAsBytes(response.bodyBytes);
      message = "Fild saved to: ${file.path}";
    } else {
      message = "Error downloading file: ${response.statusCode}";
    }
  } catch (err) {
    message = "Error: $err";
  }
}

Future downloadDepartmentQuestions(int departmentId, int year) async {
  final url =
      Uri.parse("$API_BASE_URL/questions/${departmentId}/index?year=$year");
  final userData = await getLoggedUserData();
  String? token = userData['token'];
  late String message = '';

  final response = await http.get(url, headers: {
    "Authentication": "Bearer $token",
    "Content-Type": 'application/x-www-form-urlencoded',
  });

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/data_$year.json");
    await file.writeAsString(json.encode(data));

    message = "File Saved to ${directory.path}/data_$year.json";
    return message;
  } else {
    message = "Failed to load data, please check your connection!";
    return message;
    // throw Exception("Failed to load data, Please Check your connection");
  }
}
