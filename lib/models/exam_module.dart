import 'dart:convert';

class ExamModule{
  String name;
  String department;
  String? description;

  ExamModule({required this.name, required this.department, this.description});

  // convert json to ap object
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'department': department,
      'description': description
    };
  }
  // convert a map object to ExamModule object
  factory ExamModule.fromMap(Map<String, dynamic>map) {
    return ExamModule(
      name: map['name'],
      department: map['department'],
      description: map['description'],
    );
  }

  // convert a ExamModule object to json
  String toJson() => jsonEncode(toMap());

  // convert json to ExamModule object
  factory ExamModule.fromJson(String source) => ExamModule.fromMap(jsonDecode
    (source));
}

class Course{
  String name;
  String department;
  String examModule;
  String? description;

  Course({required this.name, required this.department, required this
      .examModule, this.description});

  // convert json to map object
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'department': department,
      'examModule': examModule,
      'description': description
    };
  }
  // convert a map object to Course object
  factory Course.fromMap(Map<String, dynamic>map) {
    return Course(
      name: map['name'],
      department: map['department'],
      examModule: map['examModule'],
      description: map['description'],
    );
  }

  // convert a Course object to json
  String toJson() => jsonEncode(toMap());

  // convert json to Course object
  factory Course.fromJson(String source) => Course.fromMap(jsonDecode
    (source));
}