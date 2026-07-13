import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/core/utils/string_util.dart';

class QuizzesService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  QuizzesService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _currentUserData() async {
    final doc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(_auth.currentUser!.uid)
        .get();
    return doc.data() ?? {};
  }

  Future<void> _logActivity(String message) async {
    final instructorData = await _currentUserData();
    await _firestore
        .collection(FirestoreCollections.recentActivities)
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'dateAdded': DateTime.now(),
      'instructorInvolved': _auth.currentUser!.uid,
      'activityMessage':
          '${instructorData[UserFields.firstName]} ${instructorData[UserFields.lastName]} $message',
    });
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getAllQuizzes() async {
    try {
      final quizSnapshot =
          await _firestore.collection(FirestoreCollections.quizzes).get();
      return Right(quizSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList());
    } catch (error) {
      return Left(ServerFailure('Error getting custom quizzes: $error'));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getQuizContent(
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
      return Right(Map<String, dynamic>.from(quizContent));
    } catch (error) {
      return Left(
          ServerFailure('Error getting serialized quiz content: $error'));
    }
  }

  Future<Either<Failure, void>> archiveQuiz({
    required String quizTitle,
    required bool currentValue,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.quizzes)
          .doc(quizTitle)
          .update({QuizDocFields.isArchived: !currentValue});
      await _logActivity(
          '${currentValue == false ? 'archived' : 'restored'} quiz $quizTitle.');
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error archiving quiz: $error'));
    }
  }

  Future<Either<Failure, bool>> quizTitleExists(String quizTitle) async {
    try {
      final quiz = await _firestore
          .collection(FirestoreCollections.quizzes)
          .doc(quizTitle.trim())
          .get();
      return Right(quiz.exists);
    } catch (error) {
      return Left(
          ServerFailure('Error checking if quiz title exists: $error'));
    }
  }

  Future<Either<Failure, void>> addQuiz({
    required String quizTitle,
    required List<dynamic> easyQuestions,
    required List<dynamic> averageQuestions,
    required List<dynamic> difficultQuestions,
  }) async {
    try {
      final quizContent = {
        QuizContentFields.easy: easyQuestions,
        QuizContentFields.average: averageQuestions,
        QuizContentFields.difficult: difficultQuestions,
      };
      await _firestore
          .collection(FirestoreCollections.quizzes)
          .doc(quizTitle.trim())
          .set({
        QuizDocFields.quizContent: jsonEncode(quizContent),
        QuizDocFields.isArchived: false,
        QuizDocFields.dateAdded: DateTime.now(),
      });
      await _logActivity('added a new quiz: ${quizTitle.trim()}.');
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error uploading custom quiz: $error'));
    }
  }

  Future<Either<Failure, void>> editQuiz({
    required String quizTitle,
    required List<dynamic> easyQuestions,
    required List<dynamic> averageQuestions,
    required List<dynamic> difficultQuestions,
  }) async {
    try {
      final quizContent = {
        QuizContentFields.easy: easyQuestions,
        QuizContentFields.average: averageQuestions,
        QuizContentFields.difficult: difficultQuestions,
      };
      await _firestore
          .collection(FirestoreCollections.quizzes)
          .doc(quizTitle)
          .set({
        QuizDocFields.quizContent: jsonEncode(quizContent),
        QuizDocFields.isArchived: false,
        QuizDocFields.dateAdded: DateTime.now(),
      });
      await _logActivity('edited a quiz: $quizTitle.');
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error uploading custom quiz: $error'));
    }
  }
}
