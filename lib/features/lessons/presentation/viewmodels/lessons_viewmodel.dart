import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speechlab_dashboard/core/di/dependency_injection.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/features/lessons/domain/usecases/lessons_use_cases.dart';

class LessonsViewmodel extends StateNotifier<GenericState> {
  final LessonsUseCases lessonsUseCases;

  LessonsViewmodel({required this.lessonsUseCases})
      : super(const GenericState.initial());

  Future<List<Map<String, dynamic>>> getAllLessons() async {
    state = const GenericState.loading();
    final result = await lessonsUseCases.getAllLessons();
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <Map<String, dynamic>>[];
    }, (lessons) {
      state = GenericState.success(lessons);
      return lessons;
    });
  }

  Future<Map<String, dynamic>?> getLesson(String lessonID) async {
    state = const GenericState.loading();
    final result = await lessonsUseCases.getLesson(lessonID);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return null;
    }, (lesson) {
      state = GenericState.success(lesson);
      return lesson;
    });
  }

  Future<bool> addLesson({
    required String title,
    required String content,
    required List<Map<String, String>> additionalResources,
  }) async {
    state = const GenericState.loading();
    final result = await lessonsUseCases.addLesson(
        title: title, content: content, additionalResources: additionalResources);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> editLesson({
    required String lessonID,
    required String title,
    required String content,
    required List<Map<String, String>> additionalResources,
  }) async {
    state = const GenericState.loading();
    final result = await lessonsUseCases.editLesson(
        lessonID: lessonID,
        title: title,
        content: content,
        additionalResources: additionalResources);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> deleteLesson(String lessonID) async {
    state = const GenericState.loading();
    final result = await lessonsUseCases.deleteLesson(lessonID);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }
}

final lessonsViewModelProvider =
    StateNotifierProvider.autoDispose<LessonsViewmodel, GenericState>(
  (ref) => LessonsViewmodel(lessonsUseCases: getIt()),
);
