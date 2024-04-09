// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectshoe/services/database.dart';

class Authorization {
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> createUser(String name, String email, String password) async {
    try {
      print('Auth createUser: TRY');
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password);
      await credential.user?.updateDisplayName(name);
      User? user = FirebaseAuth.instance.currentUser;
      await Database().createNewUser(user?.uid, user?.displayName, user?.email);
      print('signed up with ${user?.displayName}');
    } catch (e) {
      print('Auth createUser: CATCH $e');
    }
  }

  Future<void> logIn(String email, String password) async {
    try {
      print('Auth logIn: TRY');
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password);
      print('logIn with ${email.trim()}');
    } catch (e) {
      print('Auth logIn: CATCH $e');
    }
  }

  Future<void> logOut() async {
    try {
      print('Auth logOut: TRY');
      await FirebaseAuth.instance.signOut();
      print('logged out');
    } catch (e) {
      print('Auth logOut: CATCH $e');
    }
  }
}
