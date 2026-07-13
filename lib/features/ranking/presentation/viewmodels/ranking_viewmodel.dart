import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speechlab_dashboard/core/di/dependency_injection.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/features/ranking/domain/usecases/ranking_use_cases.dart';

class RankingViewmodel extends StateNotifier<GenericState> {
  final RankingUseCases rankingUseCases;

  RankingViewmodel({required this.rankingUseCases})
      : super(const GenericState.initial());

  Future<List<Map<String, dynamic>>> getSectionsAndQuizzes() async {
    state = const GenericState.loading();
    final result = await rankingUseCases.getSectionsAndQuizzes();
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <Map<String, dynamic>>[];
    }, (sections) {
      state = GenericState.success(sections);
      return sections;
    });
  }

  Future<List<Map<String, dynamic>>> getQuizLeaderboard(String quizID) async {
    state = const GenericState.loading();
    final result = await rankingUseCases.getQuizLeaderboard(quizID);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <Map<String, dynamic>>[];
    }, (students) {
      state = GenericState.success(students);
      return students;
    });
  }

  Future<List<Map<String, dynamic>>> getSpeechLeaderboard(
      int currentSpeechLevelReq) async {
    state = const GenericState.loading();
    final result =
        await rankingUseCases.getSpeechLeaderboard(currentSpeechLevelReq);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <Map<String, dynamic>>[];
    }, (students) {
      state = GenericState.success(students);
      return students;
    });
  }
}

final rankingViewModelProvider =
    StateNotifierProvider.autoDispose<RankingViewmodel, GenericState>(
  (ref) => RankingViewmodel(rankingUseCases: getIt()),
);
