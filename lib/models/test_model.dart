

import 'dart:convert';

class Test {
  int? id ;
  String? userId;
  DateTime? testStarted;
  DateTime? testEnded;
  int? questions;
  double? score;

  Test({
    this.id, 
    this.userId, 
    this.testStarted, 
    this.testEnded,
    this.questions,
    this.score,
    });

  // convert Test objec to map object

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'testStarted': testStarted,
      'testEnded': testEnded,
      'questions': questions,
      'score': score,
    };
  }

  // convert map objec to test object
  factory Test.fromMap(Map<String, dynamic> map) {
    return Test(
      id: map['id'], 
      userId: map['userId'],
      testStarted: DateTime.parse(map['testStarted']),
      testEnded: DateTime.parse(map['testEnded']),
      questions: map['questions'],
      score: map['score'],
    );
  }

  // convert a Test object to json
  String toJson() => jsonEncode(toMap());

  // convert json to Test object
  factory Test.fromJson(String source) => Test.fromMap(jsonDecode(source));
}

class Exam {
  int? id ;
  String? userId;
  DateTime? examStarted;
  DateTime? examEnded;
  int? questions;
  double? score;

  Exam({
    this.id, 
    this.userId, 
    this.examStarted, 
    this.examEnded,
    this.questions,
    this.score,

  });

  // convert Exam objec to map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'examStarted': examStarted,
      'examEnded': examEnded,
      'questions': questions,
      'score': score,
    };
  }

  // convert map objec to Exam object
  factory Exam.fromMap(Map<String, dynamic> map) {

    return Exam(
      id: map['id'], 
      userId: map['userId'],
      examStarted: DateTime.parse(map['examStarted']),
      examEnded: DateTime.parse(map['examEnded']),
      questions: map['questions'],
      score: map['score'],
    );
  }

  // convert a Exam object to json
  String toJson() => jsonEncode(toMap());

  // convert json to Exam object
  factory Exam.fromJson(String source) => Exam.fromMap(jsonDecode(source));
}
