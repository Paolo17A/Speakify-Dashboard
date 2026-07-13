import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/scores/domain/repositories/scores_repository.dart';

class ScoresUseCases {
  final ScoresRepository scoresRepository;

  ScoresUseCases(this.scoresRepository);

  Future<Either<Failure, List<Map<String, dynamic>>>> getActiveQuizzes() {
    return scoresRepository.getActiveQuizzes();
  }

  Future<Either<Failure, Map<String, dynamic>>> getQuizResults(
      String quizTitle) {
    return scoresRepository.getQuizResults(quizTitle);
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getSpeechLabResults(
      int currentSpeechLevelReq) {
    return scoresRepository.getSpeechLabResults(currentSpeechLevelReq);
  }
}
