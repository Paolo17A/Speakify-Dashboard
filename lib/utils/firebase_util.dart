import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> isAdmin() async {
  final currentUser = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  final currentUserData = currentUser.data();
  return currentUserData!['userType'] == 'ADMIN';
}
