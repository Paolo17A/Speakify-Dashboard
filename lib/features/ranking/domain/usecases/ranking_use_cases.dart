import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/ranking/domain/repositories/ranking_repository.dart';

class RankingUseCases {
  final RankingRepository rankingRepository;

  RankingUseCases(this.rankingRepository);

  Future<Either<Failure, List<Map<String, dynamic>>>>
      getSectionsAndQuizzes() {
    return rankingRepository.getSectionsAndQuizzes();
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getQuizLeaderboard(
      String quizID) {
    return rankingRepository.getQuizLeaderboard(quizID);
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getSpeechLeaderboard(
      int currentSpeechLevelReq) {
    return rankingRepository.getSpeechLeaderboard(currentSpeechLevelReq);
  }
}
