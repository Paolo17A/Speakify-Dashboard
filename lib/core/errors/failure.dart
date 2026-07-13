abstract class Failure {
  final String message;

  const Failure(this.message);
}

class LogicFailure extends Failure {
  const LogicFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure()
      : super('Internet unavailable. Please check your connection.');
}
