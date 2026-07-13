import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/core/utils/string_util.dart';

class LessonsService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  LessonsService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> _logActivity(String message) async {
    final instructor = await _firestore
        .collection(FirestoreCollections.users)
        .doc(_auth.currentUser!.uid)
        .get();
    final instructorData = instructor.data() ?? {};
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

  Future<Either<Failure, List<Map<String, dynamic>>>> getAllLessons() async {
    try {
      final allLessons =
          await _firestore.collection(FirestoreCollections.lessons).get();
      return Right(allLessons.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList());
    } catch (error) {
      return Left(ServerFailure('Error getting custom lessons: $error'));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getLesson(
      String lessonID) async {
    try {
      final lesson = await _firestore
          .collection(FirestoreCollections.lessons)
          .doc(lessonID)
          .get();
      final lessonData = lesson.data();
      if (lessonData == null) {
        return const Left(ServerFailure('Lesson not found.'));
      }
      return Right({'id': lesson.id, ...lessonData});
    } catch (error) {
      return Left(ServerFailure('Error getting lesson data: $error'));
    }
  }

  Future<Either<Failure, void>> addLesson({
    required String title,
    required String content,
    required List<Map<String, String>> additionalResources,
  }) async {
    try {
      final currentLessons =
          await _firestore.collection(FirestoreCollections.lessons).get();
      int lessonCount = currentLessons.docs.length;
      String lessonID = 'lesson${lessonCount.toString().padLeft(3, '0')}';

      await _firestore
          .collection(FirestoreCollections.lessons)
          .doc(lessonID)
          .set({
        LessonDocFields.lessonTitle: title.trim(),
        LessonDocFields.lessonContent: content.trim(),
        LessonDocFields.additionalResources: additionalResources,
      });

      await _logActivity('added a new lesson: ${title.trim()}.');
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error adding new custom lesson: $error'));
    }
  }

  Future<Either<Failure, void>> editLesson({
    required String lessonID,
    required String title,
    required String content,
    required List<Map<String, String>> additionalResources,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.lessons)
          .doc(lessonID)
          .update({
        LessonDocFields.lessonTitle: title.trim(),
        LessonDocFields.lessonContent: content.trim(),
        LessonDocFields.additionalResources: additionalResources,
      });

      await _logActivity('edited this lesson: ${title.trim()}.');
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error editing custom lesson: $error'));
    }
  }

  Future<Either<Failure, void>> deleteLesson(String lessonID) async {
    try {
      final sections = await _firestore
          .collection(FirestoreCollections.sections)
          .where(SectionFields.accessedLessons, arrayContains: lessonID)
          .get();
      for (var doc in sections.docs) {
        await _firestore
            .collection(FirestoreCollections.sections)
            .doc(doc.id)
            .update({
          SectionFields.accessedLessons: FieldValue.arrayRemove([lessonID])
        });
      }
      await _firestore
          .collection(FirestoreCollections.lessons)
          .doc(lessonID)
          .delete();
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error deleting lesson: $error'));
    }
  }
}
