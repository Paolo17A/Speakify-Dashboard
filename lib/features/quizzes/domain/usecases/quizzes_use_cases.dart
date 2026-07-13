import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/quizzes/domain/repositories/quizzes_repository.dart';

class QuizzesUseCases {
  final QuizzesRepository quizzesRepository;

  QuizzesUseCases(this.quizzesRepository);

  Future<Either<Failure, List<Map<String, dynamic>>>> getAllQuizzes() {
    return quizzesRepository.getAllQuizzes();
  }

  Future<Either<Failure, Map<String, dynamic>>> getQuizContent(
      String quizTitle) {
    return quizzesRepository.getQuizContent(quizTitle);
  }

  Future<Either<Failure, void>> archiveQuiz({
    required String quizTitle,
    required bool currentValue,
  }) {
    return quizzesRepository.archiveQuiz(
        quizTitle: quizTitle, currentValue: currentValue);
  }

  Future<Either<Failure, bool>> quizTitleExists(String quizTitle) {
    return quizzesRepository.quizTitleExists(quizTitle);
  }

  Future<Either<Failure, void>> addQuiz({
    required String quizTitle,
    required List<dynamic> easyQuestions,
    required List<dynamic> averageQuestions,
    required List<dynamic> difficultQuestions,
  }) {
    return quizzesRepository.addQuiz(
        quizTitle: quizTitle,
        easyQuestions: easyQuestions,
        averageQuestions: averageQuestions,
        difficultQuestions: difficultQuestions);
  }

  Future<Either<Failure, void>> editQuiz({
    required String quizTitle,
    required List<dynamic> easyQuestions,
    required List<dynamic> averageQuestions,
    required List<dynamic> difficultQuestions,
  }) {
    return quizzesRepository.editQuiz(
        quizTitle: quizTitle,
        easyQuestions: easyQuestions,
        averageQuestions: averageQuestions,
        difficultQuestions: difficultQuestions);
  }
}
