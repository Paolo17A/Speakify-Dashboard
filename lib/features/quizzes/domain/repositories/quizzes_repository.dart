import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';

abstract class QuizzesRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllQuizzes();

  Future<Either<Failure, Map<String, dynamic>>> getQuizContent(
      String quizTitle);

  Future<Either<Failure, void>> archiveQuiz({
    required String quizTitle,
    required bool currentValue,
  });

  Future<Either<Failure, bool>> quizTitleExists(String quizTitle);

  Future<Either<Failure, void>> addQuiz({
    required String quizTitle,
    required List<dynamic> easyQuestions,
    required List<dynamic> averageQuestions,
    required List<dynamic> difficultQuestions,
  });

  Future<Either<Failure, void>> editQuiz({
    required String quizTitle,
    required List<dynamic> easyQuestions,
    required List<dynamic> averageQuestions,
    required List<dynamic> difficultQuestions,
  });
}
