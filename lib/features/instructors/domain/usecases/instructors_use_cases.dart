import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/instructors/domain/repositories/instructors_repository.dart';

class InstructorsUseCases {
  final InstructorsRepository instructorsRepository;

  InstructorsUseCases(this.instructorsRepository);

  Future<Either<Failure, List<Map<String, dynamic>>>> getAllInstructors() {
    return instructorsRepository.getAllInstructors();
  }

  Future<Either<Failure, void>> addInstructor({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    return instructorsRepository.addInstructor(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
  }

  Future<Either<Failure, void>> editInstructor({
    required String instructorUID,
    required String firstName,
    required String lastName,
  }) {
    return instructorsRepository.editInstructor(
        instructorUID: instructorUID, firstName: firstName, lastName: lastName);
  }

  Future<Either<Failure, void>> deleteInstructor({
    required String instructorUID,
    required Map<String, dynamic> instructorData,
  }) {
    return instructorsRepository.deleteInstructor(
        instructorUID: instructorUID, instructorData: instructorData);
  }

  Future<Either<Failure, Map<String, dynamic>>>
      getCurrentInstructorProfile() {
    return instructorsRepository.getCurrentInstructorProfile();
  }

  Future<Either<Failure, void>> updateOwnProfile({
    required String firstName,
    required String lastName,
    List<int>? profileImageBytes,
  }) {
    return instructorsRepository.updateOwnProfile(
      firstName: firstName,
      lastName: lastName,
      profileImageBytes: profileImageBytes,
    );
  }

  Future<Either<Failure, void>> removeOwnProfilePic() {
    return instructorsRepository.removeOwnProfilePic();
  }

  Future<Either<Failure, void>> addSectionToHandle(String sectionName) {
    return instructorsRepository.addSectionToHandle(sectionName);
  }

  Future<Either<Failure, void>> removeHandledSection(String sectionName) {
    return instructorsRepository.removeHandledSection(sectionName);
  }
}
