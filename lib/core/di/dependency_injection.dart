import 'package:get_it/get_it.dart';
import 'package:speechlab_dashboard/core/di/repository_modules.dart';
import 'package:speechlab_dashboard/core/di/service_modules.dart';
import 'package:speechlab_dashboard/core/di/usecase_modules.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await configureServiceModules();
  await configureRepositoryModules();
  await configureUseCaseModules();
}
