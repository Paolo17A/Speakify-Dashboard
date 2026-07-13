import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speechlab_dashboard/core/di/dependency_injection.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/features/sections/domain/usecases/sections_use_cases.dart';

class SectionsViewmodel extends StateNotifier<GenericState> {
  final SectionsUseCases sectionsUseCases;

  SectionsViewmodel({required this.sectionsUseCases})
      : super(const GenericState.initial());

  Future<List<String>> getAccessibleSectionNames() async {
    state = const GenericState.loading();
    final result = await sectionsUseCases.getAccessibleSectionNames();
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <String>[];
    }, (names) {
      state = GenericState.success(names);
      return names;
    });
  }

  Future<List<Map<String, dynamic>>> getSectionStudents(
      String sectionName) async {
    state = const GenericState.loading();
    final result = await sectionsUseCases.getSectionStudents(sectionName);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <Map<String, dynamic>>[];
    }, (students) {
      state = GenericState.success(students);
      return students;
    });
  }

  Future<bool> addSection(String sectionName) async {
    state = const GenericState.loading();
    final result = await sectionsUseCases.addSection(sectionName);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> editStudent({
    required String studentUID,
    required String studentID,
    required String firstName,
    required String lastName,
    required String oldSection,
    required String newSection,
  }) async {
    state = const GenericState.loading();
    final result = await sectionsUseCases.editStudent(
      studentUID: studentUID,
      studentID: studentID,
      firstName: firstName,
      lastName: lastName,
      oldSection: oldSection,
      newSection: newSection,
    );
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> deleteStudent({
    required String studentUID,
    required Map<String, dynamic> studentData,
  }) async {
    state = const GenericState.loading();
    final result = await sectionsUseCases.deleteStudent(
        studentUID: studentUID, studentData: studentData);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> addStudent({
    required String studentID,
    required String firstName,
    required String lastName,
    required String email,
    required String section,
  }) async {
    state = const GenericState.loading();
    final result = await sectionsUseCases.addStudent(
      studentID: studentID,
      firstName: firstName,
      lastName: lastName,
      email: email,
      section: section,
    );
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<Map<String, dynamic>?> getSectionDetails(String sectionName) async {
    state = const GenericState.loading();
    final result = await sectionsUseCases.getSectionDetails(sectionName);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return null;
    }, (details) {
      state = GenericState.success(details);
      return details;
    });
  }

  Future<bool> grantLessonAccess({
    required String sectionName,
    required String lessonID,
  }) async {
    state = const GenericState.loading();
    final result = await sectionsUseCases.grantLessonAccess(
        sectionName: sectionName, lessonID: lessonID);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> removeLessonAccess({
    required String sectionName,
    required String lessonID,
  }) async {
    state = const GenericState.loading();
    final result = await sectionsUseCases.removeLessonAccess(
        sectionName: sectionName, lessonID: lessonID);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> grantQuizAccess({
    required String sectionName,
    required String quizID,
  }) async {
    state = const GenericState.loading();
    final result = await sectionsUseCases.grantQuizAccess(
        sectionName: sectionName, quizID: quizID);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> removeQuizAccess({
    required String sectionName,
    required String quizID,
  }) async {
    state = const GenericState.loading();
    final result = await sectionsUseCases.removeQuizAccess(
        sectionName: sectionName, quizID: quizID);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }
}

final sectionsViewModelProvider =
    StateNotifierProvider.autoDispose<SectionsViewmodel, GenericState>(
  (ref) => SectionsViewmodel(sectionsUseCases: getIt()),
);
