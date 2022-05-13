import "package:freezed_annotation/freezed_annotation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../data/auth_repository.dart";
import "../domain/credentials.dart";
import "auth_browser.dart";

part "auth_notifier.freezed.dart";

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  /// Auth state indicating that the notifier is currently undergoing a state change.
  const factory AuthState.loading() = _Loading;

  /// Auth state indicating that an error occurred while performing the operation.
  const factory AuthState.error(String message) = _Error;

  /// Auth state indicating that the user is logged in and the credentials are valid.
  const factory AuthState.authenticated(final Credentials credentials) = _Authenticated;

  /// Auth state indicating that the user is not logged in.
  const factory AuthState.unauthenticated() = _Unauthenticated;
}

/// [StateNotifier] that notifies the presentation layer of changes to that
/// authentication state.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState.loading()) {
    refresh();
  }

  Future<void> login() async {
    final previousState = state;
    state = const AuthState.loading();
    final newState = await AuthBrowser().authorize().flatMap(_repository.addCredentials).run();
    newState.match(
      (error) {
        state = AuthState.error(error.message);
        state = previousState;
      },
      (credentials) => state = AuthState.authenticated(credentials),
    );
  }

  Future<void> logout() async {
    final previousState = state;
    state = const AuthState.loading();
    await _repository.deleteCredentials().map((_) => state = const AuthState.unauthenticated()).mapLeft((failure) {
      state = AuthState.error(failure.message);
      state = previousState;
    }).run();
  }

  Future<void> refresh() async {
    state = const AuthState.loading();
    final credentials = await _repository.retrieveCredentials();
    state = credentials.map((c) => AuthState.authenticated(c)).getOrElse(() => const AuthState.unauthenticated());
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
