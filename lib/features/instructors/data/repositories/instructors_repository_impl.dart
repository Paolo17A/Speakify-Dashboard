import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/instructors/data/services/instructors_service.dart';
import 'package:speechlab_dashboard/features/instructors/domain/repositories/instructors_repository.dart';

class InstructorsRepositoryImpl implements InstructorsRepository {
  final InstructorsService instructorsService;

  InstructorsRepositoryImpl(this.instructorsService);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllInstructors() {
    return instructorsService.getAllInstructors();
  }

  @override
  Future<Either<Failure, void>> addInstructor({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    return instructorsService.addInstructor(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
  }

  @override
  Future<Either<Failure, void>> editInstructor({
    required String instructorUID,
    required String firstName,
    required String lastName,
  }) {
    return instructorsService.editInstructor(
        instructorUID: instructorUID, firstName: firstName, lastName: lastName);
  }

  @override
  Future<Either<Failure, void>> deleteInstructor({
    required String instructorUID,
    required Map<String, dynamic> instructorData,
  }) {
    return instructorsService.deleteInstructor(
        instructorUID: instructorUID, instructorData: instructorData);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>>
      getCurrentInstructorProfile() {
    return instructorsService.getCurrentInstructorProfile();
  }

  @override
  Future<Either<Failure, void>> updateOwnProfile({
    required String firstName,
    required String lastName,
    List<int>? profileImageBytes,
  }) {
    return instructorsService.updateOwnProfile(
      firstName: firstName,
      lastName: lastName,
      profileImageBytes: profileImageBytes,
    );
  }

  @override
  Future<Either<Failure, void>> removeOwnProfilePic() {
    return instructorsService.removeOwnProfilePic();
  }

  @override
  Future<Either<Failure, void>> addSectionToHandle(String sectionName) {
    return instructorsService.addSectionToHandle(sectionName);
  }

  @override
  Future<Either<Failure, void>> removeHandledSection(String sectionName) {
    return instructorsService.removeHandledSection(sectionName);
  }
}
