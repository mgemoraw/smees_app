class UserModel {
  String uid;
  String? fname;
  String? mname;
  String? lname;
  String sex;
  String username;
  String? role;
  String email;
  String department;
  String? university;
  DateTime createdAt;

  UserModel({
    required this.uid,
    this.fname,
    this.mname,
    this.lname,
    required this.sex,
    required this.username,
    this.role,
    required this.email,
    required this.department,
    required this.createdAt,
    this.university,

  });

  // Convert UserModel to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fname': fname,
      'mname': mname,
      'lname': lname,
      'sex': sex,
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
      fname: map['fname'] ?? '',
      mname: map['mname'] ?? '',
      lname: map['lname'] ?? '',
      username: map['username'] ?? '',
      role: map['role'],
      email: map['email'],
      sex: map['sex'],
      department: map['department'],
      university: null,
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
