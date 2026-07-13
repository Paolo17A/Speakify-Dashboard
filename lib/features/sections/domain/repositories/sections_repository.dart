import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';

abstract class SectionsRepository {
  Future<Either<Failure, List<String>>> getAccessibleSectionNames();

  Future<Either<Failure, List<Map<String, dynamic>>>> getSectionStudents(
      String sectionName);

  Future<Either<Failure, void>> addSection(String sectionName);

  Future<Either<Failure, void>> editStudent({
    required String studentUID,
    required String studentID,
    required String firstName,
    required String lastName,
    required String oldSection,
    required String newSection,
  });

  Future<Either<Failure, void>> deleteStudent({
    required String studentUID,
    required Map<String, dynamic> studentData,
  });

  Future<Either<Failure, void>> addStudent({
    required String studentID,
    required String firstName,
    required String lastName,
    required String email,
    required String section,
  });

  Future<Either<Failure, Map<String, dynamic>>> getSectionDetails(
      String sectionName);

  Future<Either<Failure, void>> grantLessonAccess({
    required String sectionName,
    required String lessonID,
  });

  Future<Either<Failure, void>> removeLessonAccess({
    required String sectionName,
    required String lessonID,
  });

  Future<Either<Failure, void>> grantQuizAccess({
    required String sectionName,
    required String quizID,
  });

  Future<Either<Failure, void>> removeQuizAccess({
    required String sectionName,
    required String quizID,
  });
}
