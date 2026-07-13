import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/lessons/domain/repositories/lessons_repository.dart';

class LessonsUseCases {
  final LessonsRepository lessonsRepository;

  LessonsUseCases(this.lessonsRepository);

  Future<Either<Failure, List<Map<String, dynamic>>>> getAllLessons() {
    return lessonsRepository.getAllLessons();
  }

  Future<Either<Failure, Map<String, dynamic>>> getLesson(String lessonID) {
    return lessonsRepository.getLesson(lessonID);
  }

  Future<Either<Failure, void>> addLesson({
    required String title,
    required String content,
    required List<Map<String, String>> additionalResources,
  }) {
    return lessonsRepository.addLesson(
        title: title, content: content, additionalResources: additionalResources);
  }

  Future<Either<Failure, void>> editLesson({
    required String lessonID,
    required String title,
    required String content,
    required List<Map<String, String>> additionalResources,
  }) {
    return lessonsRepository.editLesson(
        lessonID: lessonID,
        title: title,
        content: content,
        additionalResources: additionalResources);
  }

  Future<Either<Failure, void>> deleteLesson(String lessonID) {
    return lessonsRepository.deleteLesson(lessonID);
  }
}
