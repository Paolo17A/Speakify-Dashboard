import 'package:get_it/get_it.dart';
import 'package:speechlab_dashboard/features/auth/data/services/auth_service.dart';
import 'package:speechlab_dashboard/features/home/data/services/home_service.dart';
import 'package:speechlab_dashboard/features/instructors/data/services/instructors_service.dart';
import 'package:speechlab_dashboard/features/lessons/data/services/lessons_service.dart';
import 'package:speechlab_dashboard/features/quizzes/data/services/quizzes_service.dart';
import 'package:speechlab_dashboard/features/ranking/data/services/ranking_service.dart';
import 'package:speechlab_dashboard/features/scores/data/services/scores_service.dart';
import 'package:speechlab_dashboard/features/sections/data/services/sections_service.dart';

Future<void> configureServiceModules() async {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => HomeService());
  getIt.registerLazySingleton(() => SectionsService());
  getIt.registerLazySingleton(() => InstructorsService());
  getIt.registerLazySingleton(() => LessonsService());
  getIt.registerLazySingleton(() => QuizzesService());
  getIt.registerLazySingleton(() => ScoresService());
  getIt.registerLazySingleton(() => RankingService());
}
