class UserModel {
  String uid;
  String username;
  String email;
  String department;
  String? university;
  String role;
  DateTime createdAt;
  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.department,
    required this.role,
    required this.createdAt,
    this.university,

  });

  // Convert UserModel to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'department': department,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // create UserModel from a firestore Document
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      username: map['username'] ?? '',
      email: map['email'],
      role: map['role'],
      department: map['department'],
      university: null,
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
