import 'dart:convert';

class User {
  String? username;
  String? password;
  String? fname;
  String? mname;
  String? lname;
  String? email;
  String? university;
  String? department;
  DateTime? createdAt;
  User({
    this.username,
    this.password,
    this.fname,
    this.mname,
    this.lname,
    this.email,
    this.university,
    this.department,
    this.createdAt,
  });

// convert a user object to a map object
  Map<String, dynamic> toMap(){
    return {
      'username': username,
      'password': password,
      'fname': fname,
      'mname': mname,
      'lname': lname,
      'email': email,
      'university': university,
      'department': department,
    };
  }

  // convert a map object to user object
  factory User.fromMap(Map<String, dynamic>map) {
    return User(
      username: map['username'],
    );
  }

  // convert a user object to json
  String toJson() => jsonEncode(toMap());

  // convert json to user object
  factory User.fromJson(String source) => User.fromMap(jsonDecode(source));
  
  // User({this.userId, this.fname, this.mname, this.lname, this.department});
}

class UserLogin {
  String username;
  String password;

  UserLogin({required this.username, required this.password});
}
