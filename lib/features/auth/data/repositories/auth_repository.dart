class AuthUser {
  final String id;
  final String email;

  AuthUser({required this.id, required this.email});
}

abstract class IAuthRepository {
  Future<AuthUser?> signIn(String email, String password);
  Future<void> signOut();
  Stream<AuthUser?> get authStateChanges;
}
