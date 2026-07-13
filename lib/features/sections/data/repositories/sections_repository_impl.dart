import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/sections/data/services/sections_service.dart';
import 'package:speechlab_dashboard/features/sections/domain/repositories/sections_repository.dart';

class SectionsRepositoryImpl implements SectionsRepository {
  final SectionsService sectionsService;

  SectionsRepositoryImpl(this.sectionsService);

  @override
  Future<Either<Failure, List<String>>> getAccessibleSectionNames() {
    return sectionsService.getAccessibleSectionNames();
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getSectionStudents(
      String sectionName) {
    return sectionsService.getSectionStudents(sectionName);
  }

  @override
  Future<Either<Failure, void>> addSection(String sectionName) {
    return sectionsService.addSection(sectionName);
  }

  @override
  Future<Either<Failure, void>> editStudent({
    required String studentUID,
    required String studentID,
    required String firstName,
    required String lastName,
    required String oldSection,
    required String newSection,
  }) {
    return sectionsService.editStudent(
      studentUID: studentUID,
      studentID: studentID,
      firstName: firstName,
      lastName: lastName,
      oldSection: oldSection,
      newSection: newSection,
    );
  }

  @override
  Future<Either<Failure, void>> deleteStudent({
    required String studentUID,
    required Map<String, dynamic> studentData,
  }) {
    return sectionsService.deleteStudent(
        studentUID: studentUID, studentData: studentData);
  }

  @override
  Future<Either<Failure, void>> addStudent({
    required String studentID,
    required String firstName,
    required String lastName,
    required String email,
    required String section,
  }) {
    return sectionsService.addStudent(
      studentID: studentID,
      firstName: firstName,
      lastName: lastName,
      email: email,
      section: section,
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSectionDetails(
      String sectionName) {
    return sectionsService.getSectionDetails(sectionName);
  }

  @override
  Future<Either<Failure, void>> grantLessonAccess({
    required String sectionName,
    required String lessonID,
  }) {
    return sectionsService.grantLessonAccess(
        sectionName: sectionName, lessonID: lessonID);
  }

  @override
  Future<Either<Failure, void>> removeLessonAccess({
    required String sectionName,
    required String lessonID,
  }) {
    return sectionsService.removeLessonAccess(
        sectionName: sectionName, lessonID: lessonID);
  }

  @override
  Future<Either<Failure, void>> grantQuizAccess({
    required String sectionName,
    required String quizID,
  }) {
    return sectionsService.grantQuizAccess(
        sectionName: sectionName, quizID: quizID);
  }

  @override
  Future<Either<Failure, void>> removeQuizAccess({
    required String sectionName,
    required String quizID,
  }) {
    return sectionsService.removeQuizAccess(
        sectionName: sectionName, quizID: quizID);
  }
}
