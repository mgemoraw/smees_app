class User {
  String? userId;
  String? password;
  String? univesity;
  String? department;

  User({
    this.userId,
    this.password,
    this.univesity,
    this.department,
  });
}

class UserLogin {
  String? username;
  String? password;

  UserLogin({this.username, this.password});
}
