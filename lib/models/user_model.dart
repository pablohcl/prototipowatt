import 'package:flutter/material.dart';
import 'package:prototipo/pages/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../main.dart';

class UserModel extends Model {
  // Usuário atual

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  void signUp() {}

  Future<void> signIn(String mail, String pass, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    if(_auth.currentUser != null){
      _auth.signOut();
    }

    try {
      await _auth.signInWithEmailAndPassword(email: mail, password: pass);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
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

  void signOut(BuildContext ctx) async {
    await _auth.signOut();
    if(_auth.currentUser == null) {
      Navigator.pushReplacement(ctx, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    }
  }

  void recoverPass() {}

}
