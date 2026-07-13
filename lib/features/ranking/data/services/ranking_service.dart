import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/core/utils/number_util.dart';
import 'package:speechlab_dashboard/core/utils/string_util.dart';

class RankingService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  RankingService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<bool> _isCurrentUserAdmin() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;
    final doc =
        await _firestore.collection(FirestoreCollections.users).doc(uid).get();
    return doc.data()?[UserFields.userType] == UserTypes.admin;
  }

  double _averageQuizScore(Map<String, dynamic> quizCategory) {
    double totalScore = 0;
    quizCategory.forEach((_, value) {
      totalScore += (value[QuizResultFields.score] as num).toDouble();
    });
    return totalScore / quizCategory.length;
  }

  Future<Either<Failure, List<Map<String, dynamic>>>>
      getSectionsAndQuizzes() async {
    try {
      final isAdmin = await _isCurrentUserAdmin();
      QuerySnapshot sections;
      if (isAdmin) {
        sections =
            await _firestore.collection(FirestoreCollections.sections).get();
      } else {
        sections = await _firestore
            .collection(FirestoreCollections.sections)
            .where(SectionFields.instructors,
                arrayContains: _auth.currentUser!.uid)
            .get();
      }

      final allQuizzes =
          await _firestore.collection(FirestoreCollections.quizzes).get();
      final allQuizIDs = allQuizzes.docs.map((doc) => doc.id).toList();

      final sectionsData = sections.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final accessedQuizzes =
            List<String>.from(data[SectionFields.accessedQuizzes] ?? [])
                .where((quizID) => allQuizIDs.contains(quizID))
                .toList();
        return {'sectionName': doc.id, 'accessedQuizzes': accessedQuizzes};
      }).toList();

      return Right(sectionsData);
    } catch (error) {
      return Left(ServerFailure('Error getting all sections: $error'));
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getQuizLeaderboard(
      String quizID) async {
    try {
      final users = await _firestore
          .collection(FirestoreCollections.users)
          .where(UserFields.userType, isEqualTo: UserTypes.student)
          .get();

      var eligible = users.docs
          .map((doc) => {'uid': doc.id, ...doc.data()})
          .where((data) {
        final results =
            data[UserFields.customQuizResults] as Map<String, dynamic>?;
        return results != null &&
            results.containsKey(quizID) &&
            (results[quizID] as Map<String, dynamic>).length == 3;
      }).toList();

      eligible.sort((a, b) {
        final scoreA = _averageQuizScore((a[UserFields.customQuizResults]
            as Map<String, dynamic>)[quizID]);
        final scoreB = _averageQuizScore((b[UserFields.customQuizResults]
            as Map<String, dynamic>)[quizID]);
        return scoreA.compareTo(scoreB);
      });

      return Right(eligible.reversed.toList());
    } catch (error) {
      return Left(ServerFailure('Error getting quiz leaderboard: $error'));
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getSpeechLeaderboard(
      int currentSpeechLevelReq) async {
    try {
      final users =
          await _firestore.collection(FirestoreCollections.users).get();

      var eligible = users.docs
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

      eligible.sort((a, b) {
        final scoresA = (a[UserFields.speechResults] as Map<String, dynamic>)[
                currentSpeechLevelReq.toString()]
            [SpeechResultFields.confidenceScores];
        final scoresB = (b[UserFields.speechResults] as Map<String, dynamic>)[
                currentSpeechLevelReq.toString()]
            [SpeechResultFields.confidenceScores];
        return calculateAverage(scoresA).compareTo(calculateAverage(scoresB));
      });

      return Right(eligible.reversed.toList());
    } catch (error) {
      return Left(ServerFailure('Error getting speech leaderboard: $error'));
    }
  }
}
