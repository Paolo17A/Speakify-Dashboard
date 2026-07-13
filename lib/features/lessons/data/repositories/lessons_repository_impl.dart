import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/lessons/data/services/lessons_service.dart';
import 'package:speechlab_dashboard/features/lessons/domain/repositories/lessons_repository.dart';

class LessonsRepositoryImpl implements LessonsRepository {
  final LessonsService lessonsService;

  LessonsRepositoryImpl(this.lessonsService);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllLessons() {
    return lessonsService.getAllLessons();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getLesson(String lessonID) {
    return lessonsService.getLesson(lessonID);
  }

  @override
  Future<Either<Failure, void>> addLesson({
    required String title,
    required String content,
    required List<Map<String, String>> additionalResources,
  }) {
    return lessonsService.addLesson(
        title: title, content: content, additionalResources: additionalResources);
  }

  @override
  Future<Either<Failure, void>> editLesson({
    required String lessonID,
    required String title,
    required String content,
    required List<Map<String, String>> additionalResources,
  }) {
    return lessonsService.editLesson(
        lessonID: lessonID,
        title: title,
        content: content,
        additionalResources: additionalResources);
  }

  @override
  Future<Either<Failure, void>> deleteLesson(String lessonID) {
    return lessonsService.deleteLesson(lessonID);
  }
}
