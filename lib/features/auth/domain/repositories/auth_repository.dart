import 'package:dartz/dartz.dart';
import 'package:speechlab_dashboard/core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<Either<Failure, void>> sendPasswordReset({required String email});
}
