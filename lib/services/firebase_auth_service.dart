import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/models/firestore_user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Register user
  Future<UserModel?> register(String email, String password, UserModel data) async {
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
          username: data.username,
          email: email,
          department: data.department,
          university: data.university,
          role: 'student',
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
      await _auth.signOut();
      print("email: $email, password: $password");
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // force token refresh
      await userCredential.user?.getIdToken(true);

      User? user = userCredential.user;

      if (user != null) {
        print("############ user data #################");


        // Fetch user details from firstore
        DocumentSnapshot userDoc =
            await _db.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          // this codes are added to change timestamp into datetime string
          // DateTime createdAt =userData['createdAt'].toDate();
          // userData['createdAt'] = createdAt.toString();

          final storage = FlutterSecureStorage();
          await storage.write(key:"smees_token", value: user.uid);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('smees-user', jsonEncode(userData));
          // print(userData);
          return UserModel.fromMap(userData, user.uid) ;
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

  Future <UserModel?> loginUser(String username, String password) async {

    try {
      // print("Auth: {$_auth.currentUser}");
      QuerySnapshot query = await _db.collection('users')
          .where('username', isEqualTo:username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        print(query.docs.first['email']);
        return null;
      }

      String email = query.docs.first['email'];
      // Fetch the 'createdAt' field from the document as a Timestamp
      Timestamp createdAtTimestamp = query.docs.first['createdAt'];

      // Convert the Timestamp to DateTime
      DateTime createdAt = createdAtTimestamp.toDate();
      UserModel user = UserModel(
        uid: query.docs.first.id,
        username: query.docs.first['username'],
        email: query.docs.first['email'],
        role: query.docs.first['role'],
        department: query.docs.first['department'],
        createdAt: createdAt,
      );

      final storage = FlutterSecureStorage();
      await storage.write(key:"smees_token", value: query.docs.first.id);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('smees-user', jsonEncode(user.toMap()));


      print("########### user data ###############");
      print(user.toMap());

      // UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      // // Successfully signed in
      // User? loggedUser = userCredential.user;


      if (user != null) {
        return user;
      }
      print("User logged in Successfully");
    } catch (error) {
      //
      print("Not Authenticated $error");
    }
    return null;
  }
}
