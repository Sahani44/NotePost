import 'package:note_post/services/auth/auth_exceptions.dart';
import 'package:note_post/services/auth/auth_provider.dart';
import 'package:note_post/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', (() {
    final provider = MockAuthProvider();
    test(
      'Should not be initialized to begin with',
      () {
        expect(provider._isInitialized, false);
      },
    );

    test(
      'Cant log out if not initialized',
      () {
        expect(provider.logOut(),
            throwsA(isA<NotInializedException>())); //const TypeMatcher
      },
    );

    test(
      'should be able to be initialized',
      () async {
        await provider.initialize();
        expect(provider._isInitialized, true);
      },
    );

    test(
      'User should be null after initialization',
      () {
        expect(provider.currentUser, null);
      },
    );

    test(
      'Should be able to initialize in less than 2 sec',
      () async {
        await provider.initialize();
        expect(provider._isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anypassword',
      );

      expect(badEmailUser, throwsA(isA<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'foobar',
      );

      expect(badPasswordUser, throwsA(isA<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );

      expect(provider.currentUser,user);
      expect(user.isEmailVerified,false);
    });

    test('Logged in user should be able to get verified', () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.login(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    },);
  }));
}

class NotInializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) throw NotInializedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if (!isInitialized) throw NotInializedException();
    if (email == 'foo@bar.com') throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    _user = const AuthUser(isEmailVerified: true);
  }
}
