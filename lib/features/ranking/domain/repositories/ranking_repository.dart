import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';

abstract class RankingRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getSectionsAndQuizzes();

  Future<Either<Failure, List<Map<String, dynamic>>>> getQuizLeaderboard(
      String quizID);

  Future<Either<Failure, List<Map<String, dynamic>>>> getSpeechLeaderboard(
      int currentSpeechLevelReq);
}
