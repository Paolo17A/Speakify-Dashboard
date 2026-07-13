import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/core/utils/string_util.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return const Left(AuthFailure('Unable to sign in.'));
      }
      final userDoc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(currentUser.uid)
          .get();
      final data = userDoc.data();
      if (data == null || !data.containsKey(UserFields.userType)) {
        await _auth.signOut();
        return const Left(AuthFailure('No userType parameter found'));
      }
      final userType = data[UserFields.userType] as String?;
      if (userType == UserTypes.student) {
        await _auth.signOut();
        return const Left(AuthFailure(
            'Students are not allowed to access the teacher\'s dashboard'));
      }
      if (userType != UserTypes.teacher && userType != UserTypes.admin) {
        await _auth.signOut();
        return const Left(AuthFailure('This account is not authorized.'));
      }
      return const Right(null);
    } catch (error) {
      return Left(AuthFailure('Error logging in: $error'));
    }
  }

  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;
      await _firestore.collection(FirestoreCollections.users).doc(uid).set({
        UserFields.email: email,
        UserFields.password: password,
        UserFields.firstName: firstName,
        UserFields.lastName: lastName,
        UserFields.userType: UserTypes.teacher,
        UserFields.profileImageURL: '',
        UserFields.handledSections: [],
      });

      await _firestore
          .collection(FirestoreCollections.recentActivities)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'dateAdded': DateTime.now(),
        'instructorInvolved': uid,
        'activityMessage':
            '${firstName.trim()} ${lastName.trim()} just registered.'
      });

      await _auth.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (error) {
      return Left(AuthFailure(error.message ?? error.toString()));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  Future<Either<Failure, void>> sendPasswordReset({
    required String email,
  }) async {
    try {
      final filteredUsers = await _firestore
          .collection(FirestoreCollections.users)
          .where(UserFields.email, isEqualTo: email.trim())
          .get();

      if (filteredUsers.docs.isEmpty) {
        return const Left(
            AuthFailure('There is no user with that email address.'));
      }
      if (filteredUsers.docs.first.data()[UserFields.userType] !=
          UserTypes.teacher) {
        return const Left(AuthFailure('This feature is for teachers only.'));
      }
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const Right(null);
    } catch (error) {
      return Left(
          ServerFailure('Error sending password reset email: $error'));
    }
  }
}
