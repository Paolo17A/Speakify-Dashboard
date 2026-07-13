import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';
import 'package:speechlab_dashboard/features/auth/domain/repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository authRepository;

  AuthUseCases(this.authRepository);

  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) {
    return authRepository.login(email: email, password: password);
  }

  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    return authRepository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }

  Future<Either<Failure, void>> sendPasswordReset({required String email}) {
    return authRepository.sendPasswordReset(email: email);
  }
}
