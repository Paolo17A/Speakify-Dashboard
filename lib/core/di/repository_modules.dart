import 'package:get_it/get_it.dart';
import 'package:speechlab_dashboard/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:speechlab_dashboard/features/auth/domain/repositories/auth_repository.dart';
import 'package:speechlab_dashboard/features/home/data/repositories/home_repository_impl.dart';
import 'package:speechlab_dashboard/features/home/domain/repositories/home_repository.dart';
import 'package:speechlab_dashboard/features/instructors/data/repositories/instructors_repository_impl.dart';
import 'package:speechlab_dashboard/features/instructors/domain/repositories/instructors_repository.dart';
import 'package:speechlab_dashboard/features/lessons/data/repositories/lessons_repository_impl.dart';
import 'package:speechlab_dashboard/features/lessons/domain/repositories/lessons_repository.dart';
import 'package:speechlab_dashboard/features/quizzes/data/repositories/quizzes_repository_impl.dart';
import 'package:speechlab_dashboard/features/quizzes/domain/repositories/quizzes_repository.dart';
import 'package:speechlab_dashboard/features/ranking/data/repositories/ranking_repository_impl.dart';
import 'package:speechlab_dashboard/features/ranking/domain/repositories/ranking_repository.dart';
import 'package:speechlab_dashboard/features/scores/data/repositories/scores_repository_impl.dart';
import 'package:speechlab_dashboard/features/scores/domain/repositories/scores_repository.dart';
import 'package:speechlab_dashboard/features/sections/data/repositories/sections_repository_impl.dart';
import 'package:speechlab_dashboard/features/sections/domain/repositories/sections_repository.dart';

Future<void> configureRepositoryModules() async {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt()));
  getIt.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(getIt()));
  getIt.registerLazySingleton<SectionsRepository>(
      () => SectionsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<InstructorsRepository>(
      () => InstructorsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<LessonsRepository>(
      () => LessonsRepositoryImpl(getIt()));
  getIt.registerLazySingleton<QuizzesRepository>(
      () => QuizzesRepositoryImpl(getIt()));
  getIt.registerLazySingleton<ScoresRepository>(
      () => ScoresRepositoryImpl(getIt()));
  getIt.registerLazySingleton<RankingRepository>(
      () => RankingRepositoryImpl(getIt()));
}
