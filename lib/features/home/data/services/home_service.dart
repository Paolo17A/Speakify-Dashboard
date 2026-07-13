import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/core/utils/string_util.dart';
import 'package:speechlab_dashboard/features/home/domain/repositories/home_repository.dart';

class HomeService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  HomeService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<bool> _isCurrentUserAdmin() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;
    final doc =
        await _firestore.collection(FirestoreCollections.users).doc(uid).get();
    return doc.data()?[UserFields.userType] == UserTypes.admin;
  }

  Future<Either<Failure, List<SectionCount>>>
      getAccessibleSectionCounts() async {
    try {
      final isAdmin = await _isCurrentUserAdmin();
      QuerySnapshot sections;
      if (isAdmin) {
        sections =
            await _firestore.collection(FirestoreCollections.sections).get();
      } else {
        sections = await _firestore
            .collection(FirestoreCollections.sections)
            .where(SectionFields.instructors,
                arrayContains: _auth.currentUser!.uid)
            .get();
      }
      final counts = sections.docs.map((doc) {
        final data = doc.data() as Map<dynamic, dynamic>;
        final students = List<dynamic>.from(data[SectionFields.students] ?? []);
        return SectionCount(doc.id, students.length);
      }).toList();
      return Right(counts);
    } catch (error) {
      return Left(ServerFailure('Error getting accessible sections: $error'));
    }
  }

  Future<Either<Failure, List<RecentActivityEntry>>>
      getRecentActivities() async {
    try {
      final activities = await _firestore
          .collection(FirestoreCollections.recentActivities)
          .get();
      final entries = activities.docs.map((doc) {
        final data = doc.data();
        return RecentActivityEntry(
          dateAdded: (data['dateAdded'] as Timestamp).toDate(),
          activityMessage: data['activityMessage'] as String? ?? '',
        );
      }).toList();
      entries.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      return Right(entries);
    } catch (error) {
      return Left(ServerFailure('Error getting recent activities: $error'));
    }
  }

  Future<Either<Failure, List<ActiveStudentEntry>>> getActiveStudents() async {
    try {
      final isAdmin = await _isCurrentUserAdmin();
      final students = await _firestore
          .collection(FirestoreCollections.users)
          .where(UserFields.userType, isNull: false)
          .where(UserFields.userType, isEqualTo: UserTypes.student)
          .get();

      var docs = students.docs.where((student) {
        final data = student.data();
        return data.containsKey(UserFields.lastLoginTime) &&
            _isWithinLast12Hours(
                (data[UserFields.lastLoginTime] as Timestamp).toDate());
      }).toList();

      if (!isAdmin) {
        final instructor = await _firestore
            .collection(FirestoreCollections.users)
            .doc(_auth.currentUser!.uid)
            .get();
        final handledSections =
            List<dynamic>.from(instructor.data()?[UserFields.handledSections] ?? []);
        docs = docs.where((student) {
          final data = student.data();
          return handledSections.contains(data[UserFields.section]);
        }).toList();
      }

      final entries = docs.map((doc) {
        final data = doc.data();
        return ActiveStudentEntry(
          firstName: data[UserFields.firstName] as String? ?? '',
          lastName: data[UserFields.lastName] as String? ?? '',
          profileImageURL: data[UserFields.profileImageURL] as String? ?? '',
          lastLoginTime: (data[UserFields.lastLoginTime] as Timestamp).toDate(),
        );
      }).toList();
      entries.sort((a, b) => b.lastLoginTime.compareTo(a.lastLoginTime));
      return Right(entries);
    } catch (error) {
      return Left(ServerFailure('Error getting active students: $error'));
    }
  }

  bool _isWithinLast12Hours(DateTime dateTime) {
    return DateTime.now().difference(dateTime).inHours.abs() < 12;
  }
}
