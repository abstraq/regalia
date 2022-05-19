import "package:fpdart/fpdart.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../data/credentials_repository.dart";
import "../domain/credentials.dart";

class CredentialService extends StateNotifier<AsyncValue<Option<Credentials>>> {
  final CredentialsRepository credentialsRepository;

  CredentialService(this.credentialsRepository) : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> login() async {
    state = const AsyncValue.loading();
    try {
      final credentials = await credentialsRepository.addCredentials();
      state = AsyncValue.data(Option.of(credentials));
    } catch (e) {
      state = AsyncValue.error(e);
      state = AsyncValue.data(Option.none());
    }
  }

  Future<void> logout() async {
    final previousState = state;
    state = const AsyncValue.loading();
    try {
      await credentialsRepository.deleteCredentials();
      state = AsyncValue.data(Option.none());
    } catch (e) {
      state = AsyncValue.error(e);
      state = previousState;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final credentials = await credentialsRepository.retrieveCredentials();
    state = AsyncValue.data(credentials);
  }
}

final credentialServiceProvider = StateNotifierProvider<CredentialService, AsyncValue<Option<Credentials>>>(
  (ref) {
    final credentialsRepository = ref.watch(credentialsRepositoryProvider);
    return CredentialService(credentialsRepository);
  },
);
