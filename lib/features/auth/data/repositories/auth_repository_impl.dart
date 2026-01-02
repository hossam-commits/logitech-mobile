import 'package:firebase_auth/firebase_auth.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _auth;

  FirebaseAuthRepository({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  Stream<AuthUser?> get authStateChanges => _auth.authStateChanges().map(
    (user) =>
        user != null ? AuthUser(id: user.uid, email: user.email ?? '') : null,
  );

  @override
  Future<AuthUser?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    return user != null
        ? AuthUser(id: user.uid, email: user.email ?? '')
        : null;
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
