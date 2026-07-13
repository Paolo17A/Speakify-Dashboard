class AuthSessionState {
  const AuthSessionState({
    this.authReady = false,
    this.isAuthenticated = false,
    this.uid = '',
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.userType = '',
    this.profileImageURL = '',
  });

  final bool authReady;
  final bool isAuthenticated;
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String userType;
  final String profileImageURL;

  bool get isAdmin => userType == 'ADMIN';

  String get userName => '$firstName $lastName'.trim();

  AuthSessionState copyWith({
    bool? authReady,
    bool? isAuthenticated,
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? userType,
    String? profileImageURL,
  }) {
    return AuthSessionState(
      authReady: authReady ?? this.authReady,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userType: userType ?? this.userType,
      profileImageURL: profileImageURL ?? this.profileImageURL,
    );
  }

  factory AuthSessionState.unauthenticated({bool authReady = true}) =>
      AuthSessionState(authReady: authReady);

  factory AuthSessionState.empty() => const AuthSessionState();
}
