import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/core/utils/string_util.dart';

class ScoresService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  ScoresService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<bool> _isCurrentUserAdmin() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;
    final doc =
        await _firestore.collection(FirestoreCollections.users).doc(uid).get();
    return doc.data()?[UserFields.userType] == UserTypes.admin;
  }

  Future<List<String>> _currentUserHandledSections() async {
    final doc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(_auth.currentUser!.uid)
        .get();
    return List<String>.from(doc.data()?[UserFields.handledSections] ?? []);
  }

  Future<List<Map<String, dynamic>>> _filterByHandledSections(
      List<Map<String, dynamic>> students) async {
    if (await _isCurrentUserAdmin()) return students;
    final handledSections = await _currentUserHandledSections();
    return students
        .where(
            (student) => handledSections.contains(student[UserFields.section]))
        .toList();
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getActiveQuizzes() async {
    try {
      final quizzes = await _firestore
          .collection(FirestoreCollections.quizzes)
          .where(QuizDocFields.isArchived, isEqualTo: false)
          .get();
      return Right(
          quizzes.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
    } catch (error) {
      return Left(ServerFailure('Error getting custom quizzes: $error'));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getQuizResults(
      String quizTitle) async {
    try {
      final quiz = await _firestore
          .collection(FirestoreCollections.quizzes)
          .doc(quizTitle)
          .get();
      final quizData = quiz.data();
      if (quizData == null) {
        return const Left(ServerFailure('Quiz not found.'));
      }
      final quizContent = jsonDecode(quizData[QuizDocFields.quizContent]);

      final users = await _firestore
          .collection(FirestoreCollections.users)
          .where(UserFields.userType, isEqualTo: UserTypes.student)
          .get();

      var eligibleStudents = users.docs
          .map((doc) => {'uid': doc.id, ...doc.data()})
          .where((student) {
        final results = student[UserFields.customQuizResults]
            as Map<String, dynamic>?;
        return results != null && results.containsKey(quizTitle);
      }).toList();

      eligibleStudents = await _filterByHandledSections(eligibleStudents);

      return Right({
        'quizContent': Map<String, dynamic>.from(quizContent),
        'students': eligibleStudents,
      });
    } catch (error) {
      return Left(
          ServerFailure('Error getting serialized quiz content: $error'));
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getSpeechLabResults(
      int currentSpeechLevelReq) async {
    try {
      final users =
          await _firestore.collection(FirestoreCollections.users).get();

      var eligibleStudents = users.docs
          .map((doc) => {'uid': doc.id, ...doc.data()})
          .where((data) {
        final speechResults =
            data[UserFields.speechResults] as Map<String, dynamic>?;
        return data[UserFields.userType] == UserTypes.student &&
            data.containsKey(UserFields.speechLesson) &&
            (data[UserFields.speechLesson] as num) >= currentSpeechLevelReq &&
            (speechResults?.containsKey(currentSpeechLevelReq.toString()) ??
                false);
      }).toList();

      eligibleStudents = await _filterByHandledSections(eligibleStudents);
      return Right(eligibleStudents);
    } catch (error) {
      return Left(ServerFailure('Error getting eligible students: $error'));
    }
  }
}
