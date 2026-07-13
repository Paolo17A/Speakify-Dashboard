import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';

abstract class InstructorsRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllInstructors();

  Future<Either<Failure, void>> addInstructor({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> editInstructor({
    required String instructorUID,
    required String firstName,
    required String lastName,
  });

  Future<Either<Failure, void>> deleteInstructor({
    required String instructorUID,
    required Map<String, dynamic> instructorData,
  });

  Future<Either<Failure, Map<String, dynamic>>> getCurrentInstructorProfile();

  Future<Either<Failure, void>> updateOwnProfile({
    required String firstName,
    required String lastName,
    List<int>? profileImageBytes,
  });

  Future<Either<Failure, void>> removeOwnProfilePic();

  Future<Either<Failure, void>> addSectionToHandle(String sectionName);

  Future<Either<Failure, void>> removeHandledSection(String sectionName);
}
