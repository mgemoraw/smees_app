import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smees/models/firestore_user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // add user to firebase
  Future<void> adduser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  // Fetch User from Firestore
  Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }

    return null;
  }

  // update user in firebase
  Future<void> updateUser(UserModel userData) async {
    await _db.collection('users').doc(userData.uid).update(userData.toMap());
  }

  // delete user from firestore
  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }
}
