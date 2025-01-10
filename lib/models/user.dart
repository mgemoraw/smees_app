class User {
  String? userId;
  String? password;
  String? fname;
  String? mname;
  String? lname;
  String? univesity;
  String? department;

  User({
    this.userId,
    this.password,
    this.univesity,
    this.department,
  });

  // User({this.userId, this.fname, this.mname, this.lname, this.department});
}

class UserLogin {
  String username;
  String password;

  UserLogin({required this.username, required this.password});
}
