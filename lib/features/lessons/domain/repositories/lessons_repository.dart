import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';

abstract class LessonsRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllLessons();

  Future<Either<Failure, Map<String, dynamic>>> getLesson(String lessonID);

  Future<Either<Failure, void>> addLesson({
    required String title,
    required String content,
    required List<Map<String, String>> additionalResources,
  });

  Future<Either<Failure, void>> editLesson({
    required String lessonID,
    required String title,
    required String content,
    required List<Map<String, String>> additionalResources,
  });

  Future<Either<Failure, void>> deleteLesson(String lessonID);
}
