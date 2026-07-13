import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/core/utils/string_util.dart';

class SectionsService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  SectionsService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<bool> _isCurrentUserAdmin() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;
    final doc =
        await _firestore.collection(FirestoreCollections.users).doc(uid).get();
    return doc.data()?[UserFields.userType] == UserTypes.admin;
  }

  Future<Map<String, dynamic>> _currentUserData() async {
    final doc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(_auth.currentUser!.uid)
        .get();
    return doc.data() ?? {};
  }

  Future<void> _logActivity(String message) async {
    await _firestore
        .collection(FirestoreCollections.recentActivities)
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'dateAdded': DateTime.now(),
      'instructorInvolved': _auth.currentUser!.uid,
      'activityMessage': message,
    });
  }

  Future<Either<Failure, List<String>>> getAccessibleSectionNames() async {
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
      return Right(sections.docs.map((doc) => doc.id).toList());
    } catch (error) {
      return Left(ServerFailure('Error getting all sections: $error'));
    }
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getSectionStudents(
      String sectionName) async {
    try {
      final section = await _firestore
          .collection(FirestoreCollections.sections)
          .doc(sectionName)
          .get();
      final enrolledStudents =
          List<dynamic>.from(section.data()?[SectionFields.students] ?? []);

      final students = await _firestore
          .collection(FirestoreCollections.users)
          .where(UserFields.userType, isEqualTo: UserTypes.student)
          .get();

      final result = students.docs.where((doc) {
        return enrolledStudents.contains(doc.id);
      }).map((doc) {
        return {'uid': doc.id, ...doc.data()};
      }).toList();
      return Right(result);
    } catch (error) {
      return Left(ServerFailure('Error getting all sections: $error'));
    }
  }

  Future<Either<Failure, void>> addSection(String sectionName) async {
    try {
      await _firestore
          .collection(FirestoreCollections.sections)
          .doc(sectionName.trim())
          .set({
        SectionFields.instructors: [],
        SectionFields.students: [],
        SectionFields.accessedQuizzes: [],
        SectionFields.accessedLessons: [],
      });
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error adding new section: $error'));
    }
  }

  Future<Either<Failure, void>> editStudent({
    required String studentUID,
    required String studentID,
    required String firstName,
    required String lastName,
    required String oldSection,
    required String newSection,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(studentUID)
          .update({
        UserFields.studentID: studentID.trim(),
        UserFields.firstName: firstName.trim(),
        UserFields.lastName: lastName.trim(),
      });

      if (oldSection != newSection) {
        await _firestore
            .collection(FirestoreCollections.users)
            .doc(studentUID)
            .update({UserFields.section: newSection});

        await _firestore
            .collection(FirestoreCollections.sections)
            .doc(oldSection)
            .update({
          SectionFields.students: FieldValue.arrayRemove([studentUID])
        });

        await _firestore
            .collection(FirestoreCollections.sections)
            .doc(newSection)
            .update({
          SectionFields.students: FieldValue.arrayUnion([studentUID])
        });
      }
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error editing selected user: $error'));
    }
  }

  Future<Either<Failure, void>> deleteStudent({
    required String studentUID,
    required Map<String, dynamic> studentData,
  }) async {
    try {
      final currentUserData = await _currentUserData();
      final userEmail = currentUserData[UserFields.email] as String;
      final userPassword = currentUserData[UserFields.password] as String;
      await _auth.signOut();

      final studentEmail = studentData[UserFields.email] as String;
      final studentPassword = studentData[UserFields.password] as String;
      final studentToDelete = await _auth.signInWithEmailAndPassword(
          email: studentEmail, password: studentPassword);
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(studentToDelete.user!.uid)
          .delete();
      await studentToDelete.user!.delete();

      await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error deleting student: $error'));
    }
  }

  Future<Either<Failure, void>> addStudent({
    required String studentID,
    required String firstName,
    required String lastName,
    required String email,
    required String section,
  }) async {
    try {
      final userWithThisEmail = await _firestore
          .collection(FirestoreCollections.users)
          .where(UserFields.email, isEqualTo: email.trim())
          .get();
      if (userWithThisEmail.docs.isNotEmpty) {
        return const Left(ServerFailure('Email is already in use.'));
      }

      final userWithThisStudentID = await _firestore
          .collection(FirestoreCollections.users)
          .where(UserFields.userType, isEqualTo: UserTypes.student)
          .where(UserFields.studentID, isEqualTo: studentID.trim())
          .get();
      if (userWithThisStudentID.docs.isNotEmpty) {
        return const Left(ServerFailure('Student ID is already in use'));
      }

      final currentUserData = await _currentUserData();
      final userEmail = currentUserData[UserFields.email] as String;
      final userPassword = currentUserData[UserFields.password] as String;

      await _auth.signOut();

      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: studentID);
      final newStudentUID = newUser.user!.uid;

      await _firestore
          .collection(FirestoreCollections.users)
          .doc(newStudentUID)
          .set({
        UserFields.email: email.trim(),
        UserFields.password: studentID,
        UserFields.currentLesson: 1,
        UserFields.speechLesson: 1,
        UserFields.firstName: firstName.trim(),
        UserFields.lastName: lastName.trim(),
        UserFields.userType: UserTypes.student,
        UserFields.profileImageURL: '',
        UserFields.quizResults: {},
        UserFields.customQuizResults: {},
        UserFields.speechResults: {},
        'allPodcasts': {},
        UserFields.achievements: [],
        UserFields.lastLoginTime: DateTime.now(),
        UserFields.section: section,
        UserFields.studentID: studentID.trim(),
      });

      await _firestore
          .collection(FirestoreCollections.sections)
          .doc(section)
          .update({
        SectionFields.students: FieldValue.arrayUnion([newStudentUID])
      });

      await _auth.signOut();
      await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error adding new student: $error'));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> getSectionDetails(
      String sectionName) async {
    try {
      final section = await _firestore
          .collection(FirestoreCollections.sections)
          .doc(sectionName)
          .get();
      final sectionData = section.data() ?? {};
      final accessedLessons =
          List<dynamic>.from(sectionData[SectionFields.accessedLessons] ?? []);
      final accessedQuizzes =
          List<dynamic>.from(sectionData[SectionFields.accessedQuizzes] ?? []);

      final lessons =
          await _firestore.collection(FirestoreCollections.lessons).get();
      final Map<String, String> accessedLessonsMap = {};
      final Map<String, String> allSelectableLessons = {};
      for (var lesson in lessons.docs) {
        final lessonData = lesson.data();
        final title = lessonData[LessonDocFields.lessonTitle] as String? ?? '';
        if (accessedLessons.contains(lesson.id)) {
          accessedLessonsMap[lesson.id] = title;
        } else {
          allSelectableLessons[lesson.id] = title;
        }
      }

      final quizzes =
          await _firestore.collection(FirestoreCollections.quizzes).get();
      final allSelectableQuizzes = quizzes.docs
          .where((quiz) => !accessedQuizzes.contains(quiz.id))
          .map((quiz) => quiz.id)
          .toList();

      return Right({
        'accessedLessonsMap': accessedLessonsMap,
        'allSelectableLessons': allSelectableLessons,
        'allLessonsAccessed': lessons.docs.length == accessedLessons.length,
        'accessedQuizzes': accessedQuizzes,
        'allSelectableQuizzes': allSelectableQuizzes,
        'allQuizzesAccessed': quizzes.docs.length == accessedQuizzes.length,
      });
    } catch (error) {
      return Left(ServerFailure('Error getting section details: $error'));
    }
  }

  Future<Either<Failure, void>> grantLessonAccess({
    required String sectionName,
    required String lessonID,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.sections)
          .doc(sectionName)
          .update({
        SectionFields.accessedLessons: FieldValue.arrayUnion([lessonID])
      });
      final instructorData = await _currentUserData();
      await _logActivity(
          '${instructorData[UserFields.firstName]} ${instructorData[UserFields.lastName]} granted access to lesson $lessonID to section $sectionName');
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error granting lesson access: $error'));
    }
  }

  Future<Either<Failure, void>> removeLessonAccess({
    required String sectionName,
    required String lessonID,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.sections)
          .doc(sectionName)
          .update({
        SectionFields.accessedLessons: FieldValue.arrayRemove([lessonID])
      });
      final instructorData = await _currentUserData();
      await _logActivity(
          '${instructorData[UserFields.firstName]} ${instructorData[UserFields.lastName]} removed access to lesson $lessonID to section $sectionName');
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error removing lesson access: $error'));
    }
  }

  Future<Either<Failure, void>> grantQuizAccess({
    required String sectionName,
    required String quizID,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.sections)
          .doc(sectionName)
          .update({
        SectionFields.accessedQuizzes: FieldValue.arrayUnion([quizID])
      });
      final instructorData = await _currentUserData();
      await _logActivity(
          '${instructorData[UserFields.firstName]} ${instructorData[UserFields.lastName]} granted access to quiz $quizID to section $sectionName');
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error granting quiz access: $error'));
    }
  }

  Future<Either<Failure, void>> removeQuizAccess({
    required String sectionName,
    required String quizID,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.sections)
          .doc(sectionName)
          .update({
        SectionFields.accessedQuizzes: FieldValue.arrayRemove([quizID])
      });
      final instructorData = await _currentUserData();
      await _logActivity(
          '${instructorData[UserFields.firstName]} ${instructorData[UserFields.lastName]} removed access to quiz $quizID to section $sectionName');
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error removing quiz access: $error'));
    }
  }
}
