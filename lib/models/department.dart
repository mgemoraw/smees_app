class Chair {
  String? name;
  String? code;

  Chair({this.name, this.code});
}

class Course {
  int? id;
  String? name;
  String? code;
  int? creditHour;

  Course({this.name, this.code, this.creditHour});
}

class DepartmentModel {
  String? name;
  String? description;

  DepartmentModel({this.name, this.description});
}

class Question {
  int? qid;
  int? departmentIdfk;
  String? content;
  Map<String, dynamic>? options;
  String? answer;

  Question(
      {this.qid, this.departmentIdfk, this.content, this.options, this.answer});
}
