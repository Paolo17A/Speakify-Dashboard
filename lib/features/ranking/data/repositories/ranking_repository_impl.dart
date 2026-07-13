import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/ranking/data/services/ranking_service.dart';
import 'package:speechlab_dashboard/features/ranking/domain/repositories/ranking_repository.dart';

class RankingRepositoryImpl implements RankingRepository {
  final RankingService rankingService;

  RankingRepositoryImpl(this.rankingService);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
      getSectionsAndQuizzes() {
    return rankingService.getSectionsAndQuizzes();
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getQuizLeaderboard(
      String quizID) {
    return rankingService.getQuizLeaderboard(quizID);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getSpeechLeaderboard(
      int currentSpeechLevelReq) {
    return rankingService.getSpeechLeaderboard(currentSpeechLevelReq);
  }
}
