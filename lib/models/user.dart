class User {
  String? username;
  String? password;
  String? fname;
  String? mname;
  String? lname;
  String? email;
  String? univesity;
  String? department;

  User({
    this.username,
    this.password,
    this.fname,
    this.mname,
    this.lname,
    this.email,
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
