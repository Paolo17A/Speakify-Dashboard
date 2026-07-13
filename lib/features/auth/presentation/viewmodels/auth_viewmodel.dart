import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speechlab_dashboard/core/di/dependency_injection.dart';
import 'package:speechlab_dashboard/core/utils/generic_state.dart';
import 'package:speechlab_dashboard/features/auth/domain/usecases/auth_use_cases.dart';

class AuthViewmodel extends StateNotifier<GenericState> {
  final AuthUseCases authUseCases;

  AuthViewmodel({required this.authUseCases})
      : super(const GenericState.initial());

  Future<bool> login({required String email, required String password}) async {
    state = const GenericState.loading();
    final result = await authUseCases.login(email: email, password: password);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    state = const GenericState.loading();
    final result = await authUseCases.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }

  Future<bool> sendPasswordReset({required String email}) async {
    state = const GenericState.loading();
    final result = await authUseCases.sendPasswordReset(email: email);
    return result.fold((failure) {
      state = GenericState.error(failure.message);
      return false;
    }, (_) {
      state = const GenericState.success();
      return true;
    });
  }
}

final authViewModelProvider =
    StateNotifierProvider.autoDispose<AuthViewmodel, GenericState>(
  (ref) => AuthViewmodel(authUseCases: getIt()),
);
