import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/home/data/services/home_service.dart';
import 'package:speechlab_dashboard/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeService homeService;

  HomeRepositoryImpl(this.homeService);

  @override
  Future<Either<Failure, List<SectionCount>>> getAccessibleSectionCounts() {
    return homeService.getAccessibleSectionCounts();
  }

  @override
  Future<Either<Failure, List<RecentActivityEntry>>> getRecentActivities() {
    return homeService.getRecentActivities();
  }

  @override
  Future<Either<Failure, List<ActiveStudentEntry>>> getActiveStudents() {
    return homeService.getActiveStudents();
  }
}
