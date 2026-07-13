import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/quizzes/data/services/quizzes_service.dart';
import 'package:speechlab_dashboard/features/quizzes/domain/repositories/quizzes_repository.dart';

class QuizzesRepositoryImpl implements QuizzesRepository {
  final QuizzesService quizzesService;

  QuizzesRepositoryImpl(this.quizzesService);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllQuizzes() {
    return quizzesService.getAllQuizzes();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getQuizContent(
      String quizTitle) {
    return quizzesService.getQuizContent(quizTitle);
  }

  @override
  Future<Either<Failure, void>> archiveQuiz({
    required String quizTitle,
    required bool currentValue,
  }) {
    return quizzesService.archiveQuiz(
        quizTitle: quizTitle, currentValue: currentValue);
  }

  @override
  Future<Either<Failure, bool>> quizTitleExists(String quizTitle) {
    return quizzesService.quizTitleExists(quizTitle);
  }

  @override
  Future<Either<Failure, void>> addQuiz({
    required String quizTitle,
    required List<dynamic> easyQuestions,
    required List<dynamic> averageQuestions,
    required List<dynamic> difficultQuestions,
  }) {
    return quizzesService.addQuiz(
        quizTitle: quizTitle,
        easyQuestions: easyQuestions,
        averageQuestions: averageQuestions,
        difficultQuestions: difficultQuestions);
  }

  @override
  Future<Either<Failure, void>> editQuiz({
    required String quizTitle,
    required List<dynamic> easyQuestions,
    required List<dynamic> averageQuestions,
    required List<dynamic> difficultQuestions,
  }) {
    return quizzesService.editQuiz(
        quizTitle: quizTitle,
        easyQuestions: easyQuestions,
        averageQuestions: averageQuestions,
        difficultQuestions: difficultQuestions);
  }
}
