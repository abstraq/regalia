import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:regalia/features/authentication/data/credentials_repository.dart";
import "package:regalia/features/authentication/domain/credentials.dart";

class CredentialService extends StateNotifier<AsyncValue<Credentials?>> {
  final CredentialsRepository credentialsRepository;

  CredentialService(this.credentialsRepository) : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> login() async {
    state = const AsyncValue.loading();
    try {
      final credentials = await credentialsRepository.addCredentials();
      state = AsyncValue.data(credentials);
    } catch (e) {
      state = AsyncValue.error(e);
      state = const AsyncValue.data(null);
    }
  }

  Future<void> logout() async {
    final previousState = state;
    state = const AsyncValue.loading();
    try {
      await credentialsRepository.deleteCredentials();
      state = const AsyncValue.data(null);
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

final credentialServiceProvider = StateNotifierProvider<CredentialService, AsyncValue<Credentials?>>((ref) {
  final credentialsRepository = ref.watch(credentialsRepositoryProvider);
  return CredentialService(credentialsRepository);
});
