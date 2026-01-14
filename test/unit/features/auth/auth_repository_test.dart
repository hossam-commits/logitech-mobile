import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logitech_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User])
void main() {
  late MockFirebaseAuth mockAuth;
  late FirebaseAuthRepository repository;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    repository = FirebaseAuthRepository(auth: mockAuth);
  });

  group('FirebaseAuthRepository', () {
    test('signIn returns AuthUser on success', () async {
      final mockUser = MockUser();
      final mockCredential = MockUserCredential();

      when(mockUser.uid).thenReturn('123');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockCredential.user).thenReturn(mockUser);

      when(
        mockAuth.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        ),
      ).thenAnswer((_) async => mockCredential);

      final result = await repository.signIn('test@example.com', 'password');

      expect(result?.id, '123');
      expect(result?.email, 'test@example.com');
    });

    test('signOut calls FirebaseAuth.signOut', () async {
      when(mockAuth.signOut()).thenAnswer((_) async => {});

      await repository.signOut();

      verify(mockAuth.signOut()).called(1);
    });
  });
}
