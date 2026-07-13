import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/sections/domain/repositories/sections_repository.dart';

class SectionsUseCases {
  final SectionsRepository sectionsRepository;

  SectionsUseCases(this.sectionsRepository);

  Future<Either<Failure, List<String>>> getAccessibleSectionNames() {
    return sectionsRepository.getAccessibleSectionNames();
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getSectionStudents(
      String sectionName) {
    return sectionsRepository.getSectionStudents(sectionName);
  }

  Future<Either<Failure, void>> addSection(String sectionName) {
    return sectionsRepository.addSection(sectionName);
  }

  Future<Either<Failure, void>> editStudent({
    required String studentUID,
    required String studentID,
    required String firstName,
    required String lastName,
    required String oldSection,
    required String newSection,
  }) {
    return sectionsRepository.editStudent(
      studentUID: studentUID,
      studentID: studentID,
      firstName: firstName,
      lastName: lastName,
      oldSection: oldSection,
      newSection: newSection,
    );
  }

  Future<Either<Failure, void>> deleteStudent({
    required String studentUID,
    required Map<String, dynamic> studentData,
  }) {
    return sectionsRepository.deleteStudent(
        studentUID: studentUID, studentData: studentData);
  }

  Future<Either<Failure, void>> addStudent({
    required String studentID,
    required String firstName,
    required String lastName,
    required String email,
    required String section,
  }) {
    return sectionsRepository.addStudent(
      studentID: studentID,
      firstName: firstName,
      lastName: lastName,
      email: email,
      section: section,
    );
  }

  Future<Either<Failure, Map<String, dynamic>>> getSectionDetails(
      String sectionName) {
    return sectionsRepository.getSectionDetails(sectionName);
  }

  Future<Either<Failure, void>> grantLessonAccess({
    required String sectionName,
    required String lessonID,
  }) {
    return sectionsRepository.grantLessonAccess(
        sectionName: sectionName, lessonID: lessonID);
  }

  Future<Either<Failure, void>> removeLessonAccess({
    required String sectionName,
    required String lessonID,
  }) {
    return sectionsRepository.removeLessonAccess(
        sectionName: sectionName, lessonID: lessonID);
  }

  Future<Either<Failure, void>> grantQuizAccess({
    required String sectionName,
    required String quizID,
  }) {
    return sectionsRepository.grantQuizAccess(
        sectionName: sectionName, quizID: quizID);
  }

  Future<Either<Failure, void>> removeQuizAccess({
    required String sectionName,
    required String quizID,
  }) {
    return sectionsRepository.removeQuizAccess(
        sectionName: sectionName, quizID: quizID);
  }
}
