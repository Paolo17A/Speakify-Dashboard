import 'package:get_it/get_it.dart';
import 'package:speechlab_dashboard/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:speechlab_dashboard/features/home/domain/usecases/home_use_cases.dart';
import 'package:speechlab_dashboard/features/instructors/domain/usecases/instructors_use_cases.dart';
import 'package:speechlab_dashboard/features/lessons/domain/usecases/lessons_use_cases.dart';
import 'package:speechlab_dashboard/features/quizzes/domain/usecases/quizzes_use_cases.dart';
import 'package:speechlab_dashboard/features/ranking/domain/usecases/ranking_use_cases.dart';
import 'package:speechlab_dashboard/features/scores/domain/usecases/scores_use_cases.dart';
import 'package:speechlab_dashboard/features/sections/domain/usecases/sections_use_cases.dart';

Future<void> configureUseCaseModules() async {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton(() => AuthUseCases(getIt()));
  getIt.registerLazySingleton(() => HomeUseCases(getIt()));
  getIt.registerLazySingleton(() => SectionsUseCases(getIt()));
  getIt.registerLazySingleton(() => InstructorsUseCases(getIt()));
  getIt.registerLazySingleton(() => LessonsUseCases(getIt()));
  getIt.registerLazySingleton(() => QuizzesUseCases(getIt()));
  getIt.registerLazySingleton(() => ScoresUseCases(getIt()));
  getIt.registerLazySingleton(() => RankingUseCases(getIt()));
}
