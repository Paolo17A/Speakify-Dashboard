import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/core/utils/string_util.dart';

class InstructorsService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  InstructorsService(
      {FirebaseAuth? auth, FirebaseFirestore? firestore, FirebaseStorage? storage})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

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

  Future<Either<Failure, List<Map<String, dynamic>>>>
      getAllInstructors() async {
    try {
      final allInstructors = await _firestore
          .collection(FirestoreCollections.users)
          .where(UserFields.userType, isNull: false)
          .where(UserFields.userType, isEqualTo: UserTypes.teacher)
          .get();
      return Right(allInstructors.docs
          .map((doc) => {'uid': doc.id, ...doc.data()})
          .toList());
    } catch (error) {
      return Left(ServerFailure('Error getting all instructors: $error'));
    }
  }

  Future<Either<Failure, void>> addInstructor({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final userWithThisEmail = await _firestore
          .collection(FirestoreCollections.users)
          .where(UserFields.email, isEqualTo: email.trim())
          .get();
      if (userWithThisEmail.docs.isNotEmpty) {
        return const Left(ServerFailure('Email is already in use.'));
      }

      final currentUserData = await _currentUserData();
      final userEmail = currentUserData[UserFields.email] as String;
      final userPassword = currentUserData[UserFields.password] as String;

      await _auth.signOut();

      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final newInstructorUID = newUser.user!.uid;

      await _firestore
          .collection(FirestoreCollections.users)
          .doc(newInstructorUID)
          .set({
        UserFields.email: email,
        UserFields.password: password,
        UserFields.firstName: firstName,
        UserFields.lastName: lastName,
        UserFields.userType: UserTypes.teacher,
        UserFields.profileImageURL: '',
        UserFields.handledSections: [],
      });

      await _auth.signOut();
      await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error adding new instructor: $error'));
    }
  }

  Future<Either<Failure, void>> editInstructor({
    required String instructorUID,
    required String firstName,
    required String lastName,
  }) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(instructorUID)
          .update({
        UserFields.firstName: firstName.trim(),
        UserFields.lastName: lastName.trim(),
      });
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error editing selected user: $error'));
    }
  }

  Future<Either<Failure, void>> deleteInstructor({
    required String instructorUID,
    required Map<String, dynamic> instructorData,
  }) async {
    try {
      final instructorHandledSections =
          List<dynamic>.from(instructorData[UserFields.handledSections] ?? []);
      for (var section in instructorHandledSections) {
        await _firestore
            .collection(FirestoreCollections.sections)
            .doc(section)
            .update({
          SectionFields.instructors: FieldValue.arrayRemove([instructorUID])
        });
      }

      final currentUserData = await _currentUserData();
      final userEmail = currentUserData[UserFields.email] as String;
      final userPassword = currentUserData[UserFields.password] as String;
      await _auth.signOut();

      final instructorEmail = instructorData[UserFields.email] as String;
      final instructorPassword = instructorData[UserFields.password] as String;
      final instructorToDelete = await _auth.signInWithEmailAndPassword(
          email: instructorEmail, password: instructorPassword);
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(instructorToDelete.user!.uid)
          .delete();
      await instructorToDelete.user!.delete();

      await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error deleting selected instructor: $error'));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>>
      getCurrentInstructorProfile() async {
    try {
      final currentUserData = await _currentUserData();
      final handledSections =
          List<dynamic>.from(currentUserData[UserFields.handledSections] ?? []);

      final sections =
          await _firestore.collection(FirestoreCollections.sections).get();
      final allSelectableSections = sections.docs
          .where((doc) => !handledSections.contains(doc.id))
          .map((doc) => doc.id)
          .toList();

      return Right({
        'firstName': currentUserData[UserFields.firstName] ?? '',
        'lastName': currentUserData[UserFields.lastName] ?? '',
        'profileImageURL': currentUserData[UserFields.profileImageURL] ?? '',
        'handledSections': handledSections,
        'allSelectableSections': allSelectableSections,
        'allSectionsHandled': allSelectableSections.isEmpty,
      });
    } catch (error) {
      return Left(ServerFailure('Error getting current user data: $error'));
    }
  }

  Future<Either<Failure, void>> updateOwnProfile({
    required String firstName,
    required String lastName,
    List<int>? profileImageBytes,
  }) async {
    try {
      final instructorData = await _currentUserData();

      await _logActivity(
          '${instructorData[UserFields.firstName]} ${instructorData[UserFields.lastName]} changed their name to ${firstName.trim()} ${lastName.trim()}.');

      await _firestore
          .collection(FirestoreCollections.users)
          .doc(_auth.currentUser!.uid)
          .update({
        UserFields.firstName: firstName.trim(),
        UserFields.lastName: lastName.trim(),
      });

      if (profileImageBytes != null) {
        final storageRef = _storage
            .ref()
            .child(StoragePaths.profilePics)
            .child(_auth.currentUser!.uid);

        final uploadTask =
            storageRef.putData(Uint8List.fromList(profileImageBytes));
        final taskSnapshot = await uploadTask.whenComplete(() {});
        final downloadURL = await taskSnapshot.ref.getDownloadURL();

        await _firestore
            .collection(FirestoreCollections.users)
            .doc(_auth.currentUser!.uid)
            .update({UserFields.profileImageURL: downloadURL});

        await _logActivity(
            '${firstName.trim()} ${lastName.trim()} changed their profile picture.');
      }
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error updating user profile: $error'));
    }
  }

  Future<Either<Failure, void>> removeOwnProfilePic() async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(_auth.currentUser!.uid)
          .update({UserFields.profileImageURL: ''});

      final storageRef = _storage
          .ref()
          .child(StoragePaths.profilePics)
          .child(_auth.currentUser!.uid);
      await storageRef.delete();

      final instructorData = await _currentUserData();
      await _logActivity(
          '${instructorData[UserFields.firstName]} ${instructorData[UserFields.lastName]} removed their profile picture.');
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure('Error removing current profile pic: $error'));
    }
  }

  Future<Either<Failure, void>> addSectionToHandle(String sectionName) async {
    try {
      final uid = _auth.currentUser!.uid;
      await _firestore.collection(FirestoreCollections.users).doc(uid).update({
        UserFields.handledSections: FieldValue.arrayUnion([sectionName])
      });

      await _firestore
          .collection(FirestoreCollections.sections)
          .doc(sectionName)
          .update({
        SectionFields.instructors: FieldValue.arrayUnion([uid])
      });

      final instructorData = await _currentUserData();
      await _logActivity(
          '${instructorData[UserFields.firstName]} ${instructorData[UserFields.lastName]} added $sectionName to their handled sections.');
      return const Right(null);
    } catch (error) {
      return Left(
          ServerFailure('Error adding this section to handled sections: $error'));
    }
  }

  Future<Either<Failure, void>> removeHandledSection(String sectionName) async {
    try {
      final uid = _auth.currentUser!.uid;
      await _firestore.collection(FirestoreCollections.users).doc(uid).update({
        UserFields.handledSections: FieldValue.arrayRemove([sectionName])
      });

      await _firestore
          .collection(FirestoreCollections.sections)
          .doc(sectionName)
          .update({
        SectionFields.instructors: FieldValue.arrayRemove([uid])
      });

      final instructorData = await _currentUserData();
      await _logActivity(
          '${instructorData[UserFields.firstName]} ${instructorData[UserFields.lastName]} removed $sectionName from their handled sections.');
      return const Right(null);
    } catch (error) {
      return Left(
          ServerFailure('Error removing this handled section: $error'));
    }
  }
}
