import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speechlab_dashboard/core/di/dependency_injection.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/features/scores/domain/usecases/scores_use_cases.dart';

class ScoresViewmodel extends StateNotifier<GenericState> {
  final ScoresUseCases scoresUseCases;

  ScoresViewmodel({required this.scoresUseCases})
      : super(const GenericState.initial());

  Future<List<Map<String, dynamic>>> getActiveQuizzes() async {
    state = const GenericState.loading();
    final result = await scoresUseCases.getActiveQuizzes();
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <Map<String, dynamic>>[];
    }, (quizzes) {
      state = GenericState.success(quizzes);
      return quizzes;
    });
  }

  Future<Map<String, dynamic>?> getQuizResults(String quizTitle) async {
    state = const GenericState.loading();
    final result = await scoresUseCases.getQuizResults(quizTitle);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return null;
    }, (results) {
      state = GenericState.success(results);
      return results;
    });
  }

  Future<List<Map<String, dynamic>>> getSpeechLabResults(
      int currentSpeechLevelReq) async {
    state = const GenericState.loading();
    final result =
        await scoresUseCases.getSpeechLabResults(currentSpeechLevelReq);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <Map<String, dynamic>>[];
    }, (students) {
      state = GenericState.success(students);
      return students;
    });
  }
}

final scoresViewModelProvider =
    StateNotifierProvider.autoDispose<ScoresViewmodel, GenericState>(
  (ref) => ScoresViewmodel(scoresUseCases: getIt()),
);
