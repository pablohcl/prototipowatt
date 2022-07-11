import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class UserModel extends Model {
  // Usuário atual

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  void signUp() {}

  Future<void> signIn(String mail, String pass, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: mail, password: pass);
      print(_auth.currentUser!.email);
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Falha no login!"),
          content: Text("${e.message}"),
        ),
      );
    }

    isLoading = false;
    notifyListeners();
  }

  void recoverPass() {}
}
