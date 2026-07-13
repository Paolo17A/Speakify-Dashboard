import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/scores/data/services/scores_service.dart';
import 'package:speechlab_dashboard/features/scores/domain/repositories/scores_repository.dart';

class ScoresRepositoryImpl implements ScoresRepository {
  final ScoresService scoresService;

  ScoresRepositoryImpl(this.scoresService);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getActiveQuizzes() {
    return scoresService.getActiveQuizzes();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getQuizResults(
      String quizTitle) {
    return scoresService.getQuizResults(quizTitle);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getSpeechLabResults(
      int currentSpeechLevelReq) {
    return scoresService.getSpeechLabResults(currentSpeechLevelReq);
  }
}
