import 'auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> login({
    required 
  });
}