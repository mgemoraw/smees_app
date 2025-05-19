
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api/end_points.dart';


class DropdownService {
  DropdownService();

  Future<Map<String, List<Map<String, dynamic>>>> fetchDropdownData() async {
    final departmentRes = await http.get(Uri.parse('$API_BASE_URL/departments/index'));
    final universityRes = await http.get(Uri.parse('$API_BASE_URL/universities/index'));

    if (departmentRes.statusCode == 200 && universityRes.statusCode == 200) {
      final List<dynamic> depData = jsonDecode(departmentRes.body);
      final List<dynamic> unData = jsonDecode(universityRes.body);

      return {
        'departments': List<Map<String, dynamic>>.from(depData),
        'universities': List<Map<String, dynamic>>.from(unData),
      };
    } else {
      throw Exception('Failed to load dropdown data');
    }
  }

}

