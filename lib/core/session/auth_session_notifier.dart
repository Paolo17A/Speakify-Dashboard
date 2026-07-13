import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speechlab_dashboard/core/session/auth_session_state.dart';
import 'package:speechlab_dashboard/core/utils/string_util.dart';

/// Notifies GoRouter when auth session changes so redirects re-run.
class AuthRefreshListenable extends ChangeNotifier {
  AuthSessionState session = AuthSessionState.empty();

  void publish(AuthSessionState next) {
    session = next;
    notifyListeners();
  }
}

final authRefreshListenable = AuthRefreshListenable();

class AuthSessionNotifier extends StateNotifier<AuthSessionState> {
  AuthSessionNotifier({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    AuthRefreshListenable? refreshListenable,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _refreshListenable = refreshListenable ?? authRefreshListenable,
        super(AuthSessionState.empty()) {
    _subscription = _auth.authStateChanges().listen(_onAuthChanged);
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final AuthRefreshListenable _refreshListenable;
  StreamSubscription<User?>? _subscription;

  void _emit(AuthSessionState next) {
    state = next;
    _refreshListenable.publish(next);
  }

  Future<void> _onAuthChanged(User? user) async {
    if (user == null) {
      _emit(AuthSessionState.unauthenticated(authReady: true));
      return;
    }

    try {
      final doc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .get();
      final data = doc.data();
      if (data == null) {
        _emit(AuthSessionState.unauthenticated(authReady: true));
        return;
      }

      final userType = (data[UserFields.userType] as String?) ?? '';
      if (userType == UserTypes.student) {
        await _auth.signOut();
        _emit(AuthSessionState.unauthenticated(authReady: true));
        return;
      }

      _emit(AuthSessionState(
        authReady: true,
        isAuthenticated: true,
        uid: user.uid,
        email: user.email ?? (data[UserFields.email] as String? ?? ''),
        firstName: (data[UserFields.firstName] as String?) ?? '',
        lastName: (data[UserFields.lastName] as String?) ?? '',
        userType: userType,
        profileImageURL: (data[UserFields.profileImageURL] as String?) ?? '',
      ));
    } catch (_) {
      _emit(AuthSessionState(
        authReady: true,
        isAuthenticated: true,
        uid: user.uid,
        email: user.email ?? '',
      ));
    }
  }

  Future<void> refreshProfile() async {
    await _onAuthChanged(_auth.currentUser);
  }

  Future<void> clear() async {
    await _auth.signOut();
    _emit(AuthSessionState.unauthenticated(authReady: true));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final authSessionProvider =
    StateNotifierProvider<AuthSessionNotifier, AuthSessionState>(
  (ref) => AuthSessionNotifier(),
);
