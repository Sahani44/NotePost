import 'auth_exceptions.dart';
import 'auth_provider.dart';
import 'auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth,FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({required String email, required String password}) {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password,);
    } on FirebaseAuthException catch (e) {

    } catch (_) {

    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    
      return user!=null ? AuthUser.fromFirebase(user) : null;
     
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }

}