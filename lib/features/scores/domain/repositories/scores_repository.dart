import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';

abstract class ScoresRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getActiveQuizzes();

  Future<Either<Failure, Map<String, dynamic>>> getQuizResults(
      String quizTitle);

  Future<Either<Failure, List<Map<String, dynamic>>>> getSpeechLabResults(
      int currentSpeechLevelReq);
}
