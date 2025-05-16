import 'dart:convert';

class TestSchema {
  final int id;
  final String userId;
  final int departmentId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime startedAt;
  final DateTime completedAt;
  final List<dynamic> responses;

  TestSchema({
    required this.id,
    required this.userId,
    required this.departmentId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.startedAt,
    required this.completedAt,
    required this.responses,
  });

  // Factory constructor to create a Test from JSON
  factory TestSchema.fromJson(Map<String, dynamic> json) {
    return TestSchema(
      id: json['id'],
      userId: json['user_id'],
      departmentId: json['department_id'],
      score: json['score'],
      totalQuestions: json['total_questions'],
      correctAnswers: json['correct_answers'],
      startedAt: DateTime.parse(json['started_at']),  // Convert string to DateTime
      completedAt: DateTime.parse(json['completed_at']),  // Convert string to DateTime
      responses: List<dynamic>.from(json['responses']),  // Parse responses list
    );
  }

  // Method to convert Test object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'department_id': departmentId,
      'score': score,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'started_at': startedAt.toIso8601String(),  // Convert DateTime back to string
      'completed_at': completedAt.toIso8601String(),  // Convert DateTime back to string
      'responses': responses,
    };
  }
}
