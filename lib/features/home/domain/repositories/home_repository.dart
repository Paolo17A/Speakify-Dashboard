import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<SectionCount>>> getAccessibleSectionCounts();
  Future<Either<Failure, List<RecentActivityEntry>>> getRecentActivities();
  Future<Either<Failure, List<ActiveStudentEntry>>> getActiveStudents();
}

class SectionCount {
  final String section;
  final int students;
  const SectionCount(this.section, this.students);
}

class RecentActivityEntry {
  final DateTime dateAdded;
  final String activityMessage;
  const RecentActivityEntry({
    required this.dateAdded,
    required this.activityMessage,
  });
}

class ActiveStudentEntry {
  final String firstName;
  final String lastName;
  final String profileImageURL;
  final DateTime lastLoginTime;
  const ActiveStudentEntry({
    required this.firstName,
    required this.lastName,
    required this.profileImageURL,
    required this.lastLoginTime,
  });
}
