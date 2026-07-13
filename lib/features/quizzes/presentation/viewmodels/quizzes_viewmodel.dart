import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speechlab_dashboard/core/di/dependency_injection.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/features/quizzes/domain/usecases/quizzes_use_cases.dart';

class QuizzesViewmodel extends StateNotifier<GenericState> {
  final QuizzesUseCases quizzesUseCases;

  QuizzesViewmodel({required this.quizzesUseCases})
      : super(const GenericState.initial());

  Future<List<Map<String, dynamic>>> getAllQuizzes() async {
    state = const GenericState.loading();
    final result = await quizzesUseCases.getAllQuizzes();
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <Map<String, dynamic>>[];
    }, (quizzes) {
      state = GenericState.success(quizzes);
      return quizzes;
    });
  }

  Future<Map<String, dynamic>?> getQuizContent(String quizTitle) async {
    state = const GenericState.loading();
    final result = await quizzesUseCases.getQuizContent(quizTitle);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return null;
    }, (content) {
      state = GenericState.success(content);
      return content;
    });
  }

  Future<bool> archiveQuiz({
    required String quizTitle,
    required bool currentValue,
  }) async {
    state = const GenericState.loading();
    final result = await quizzesUseCases.archiveQuiz(
        quizTitle: quizTitle, currentValue: currentValue);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> quizTitleExists(String quizTitle) async {
    state = const GenericState.loading();
    final result = await quizzesUseCases.quizTitleExists(quizTitle);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (exists) {
      state = GenericState.success(exists);
      return exists;
    });
  }

  Future<bool> addQuiz({
    required String quizTitle,
    required List<dynamic> easyQuestions,
    required List<dynamic> averageQuestions,
    required List<dynamic> difficultQuestions,
  }) async {
    state = const GenericState.loading();
    final result = await quizzesUseCases.addQuiz(
        quizTitle: quizTitle,
        easyQuestions: easyQuestions,
        averageQuestions: averageQuestions,
        difficultQuestions: difficultQuestions);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> editQuiz({
    required String quizTitle,
    required List<dynamic> easyQuestions,
    required List<dynamic> averageQuestions,
    required List<dynamic> difficultQuestions,
  }) async {
    state = const GenericState.loading();
    final result = await quizzesUseCases.editQuiz(
        quizTitle: quizTitle,
        easyQuestions: easyQuestions,
        averageQuestions: averageQuestions,
        difficultQuestions: difficultQuestions);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }
}

final quizzesViewModelProvider =
    StateNotifierProvider.autoDispose<QuizzesViewmodel, GenericState>(
  (ref) => QuizzesViewmodel(quizzesUseCases: getIt()),
);
