import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get user_ => _auth.authStateChanges();

  reload() async {
    return _auth.currentUser?.reload();
  }

  //create user object based on firebase user
  UserId? _userFromFirebaseUser(User? user) {
    return user != null ? UserId() : null;
  }

  //auth change user stream
  Stream<Object?> get user {
    if (UserId().toVerificationPage == false) {
      return _auth.authStateChanges().map(_userFromFirebaseUser);
    } else {
      return _auth.authStateChanges();
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User users = result.user!;
      if (!users.emailVerified) {
        await users.sendEmailVerification();
      }
      return _userFromFirebaseUser(users);
    } on FirebaseAuthException catch (e) {
      String error = e.message.toString();
      return error;
    }
  }

  //sign up with email and password
  Future registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      String error = e.message.toString();
      return error;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      //print(e.toString());
      return null;
    }
  }
}
