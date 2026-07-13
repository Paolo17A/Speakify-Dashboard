import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/auth/data/services/auth_service.dart';
import 'package:speechlab_dashboard/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) {
    return authService.login(email: email, password: password);
  }

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    return authService.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }

  @override
  Future<Either<Failure, void>> sendPasswordReset({required String email}) {
    return authService.sendPasswordReset(email: email);
  }
}
