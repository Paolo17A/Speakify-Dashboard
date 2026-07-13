import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/home/domain/repositories/home_repository.dart';

class HomeUseCases {
  final HomeRepository homeRepository;

  HomeUseCases(this.homeRepository);

  Future<Either<Failure, List<SectionCount>>> getAccessibleSectionCounts() {
    return homeRepository.getAccessibleSectionCounts();
  }

  Future<Either<Failure, List<RecentActivityEntry>>> getRecentActivities() {
    return homeRepository.getRecentActivities();
  }

  Future<Either<Failure, List<ActiveStudentEntry>>> getActiveStudents() {
    return homeRepository.getActiveStudents();
  }
}
