import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smees/models/firestore_user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Register user
  Future<UserModel?> register(
      String email, String password, String username, String department,
      {role = "student"}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          username: username,
          email: email,
          department: department,
          role: role,
          createdAt: DateTime.now(),
        );

        // save user to firebase
        await _db.collection("users").doc(user.uid).set(newUser.toMap());
        return newUser;
      }
    } catch (err) {
      print("Error: $err");
    }
    return null;
  }

  // login user
  Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        // Fetch user details from firstore
        DocumentSnapshot userDoc =
            await _db.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          return UserModel.fromMap(
              userDoc.data() as Map<String, dynamic>, user.uid);
        }
      }
    } catch (err) {
      print("Login Error: $err");
    }
    return null;
  }

  // logout User
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get Current User
  Future<UserModel?> getCurrentuser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _db.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        return UserModel.fromMap(
            userDoc.data() as Map<String, dynamic>, user.uid);
      }
    }
    return null;
  }
}
