import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speechlab_dashboard/core/di/dependency_injection.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/features/instructors/domain/usecases/instructors_use_cases.dart';

class InstructorsViewmodel extends StateNotifier<GenericState> {
  final InstructorsUseCases instructorsUseCases;

  InstructorsViewmodel({required this.instructorsUseCases})
      : super(const GenericState.initial());

  Future<List<Map<String, dynamic>>> getAllInstructors() async {
    state = const GenericState.loading();
    final result = await instructorsUseCases.getAllInstructors();
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return <Map<String, dynamic>>[];
    }, (instructors) {
      state = GenericState.success(instructors);
      return instructors;
    });
  }

  Future<bool> addInstructor({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = const GenericState.loading();
    final result = await instructorsUseCases.addInstructor(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> editInstructor({
    required String instructorUID,
    required String firstName,
    required String lastName,
  }) async {
    state = const GenericState.loading();
    final result = await instructorsUseCases.editInstructor(
        instructorUID: instructorUID, firstName: firstName, lastName: lastName);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> deleteInstructor({
    required String instructorUID,
    required Map<String, dynamic> instructorData,
  }) async {
    state = const GenericState.loading();
    final result = await instructorsUseCases.deleteInstructor(
        instructorUID: instructorUID, instructorData: instructorData);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<Map<String, dynamic>?> getCurrentInstructorProfile() async {
    state = const GenericState.loading();
    final result = await instructorsUseCases.getCurrentInstructorProfile();
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return null;
    }, (profile) {
      state = GenericState.success(profile);
      return profile;
    });
  }

  Future<bool> updateOwnProfile({
    required String firstName,
    required String lastName,
    List<int>? profileImageBytes,
  }) async {
    state = const GenericState.loading();
    final result = await instructorsUseCases.updateOwnProfile(
      firstName: firstName,
      lastName: lastName,
      profileImageBytes: profileImageBytes,
    );
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> removeOwnProfilePic() async {
    state = const GenericState.loading();
    final result = await instructorsUseCases.removeOwnProfilePic();
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> addSectionToHandle(String sectionName) async {
    state = const GenericState.loading();
    final result = await instructorsUseCases.addSectionToHandle(sectionName);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> removeHandledSection(String sectionName) async {
    state = const GenericState.loading();
    final result = await instructorsUseCases.removeHandledSection(sectionName);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }
}

final instructorsViewModelProvider =
    StateNotifierProvider.autoDispose<InstructorsViewmodel, GenericState>(
  (ref) => InstructorsViewmodel(instructorsUseCases: getIt()),
);
