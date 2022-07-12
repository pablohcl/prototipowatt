import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prototipo/main.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String senha = "";
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    verificaSeEstaLogado();
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                TextFormField(
                  validator: (text) {
                    if (text!.isEmpty) return "Preencha o e-mail!";
                  },
                  onChanged: (txt) {
                    email = txt;
                  },
                  decoration: InputDecoration(
                    hintText: "Usuário",
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  validator: (text) {
                    if (text!.isEmpty) return "Preencha a senha!";
                  },
                  onChanged: (txt) {
                    senha = txt;
                  },
                  decoration: InputDecoration(
                    hintText: "Senha",
                  ),
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Esqueci minha senha",
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          model.signIn(email, senha, context);
                        }
                      },
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )),
                )
              ],
            ),
          );
        },
      ),
    );
  }
  void verificaSeEstaLogado(){
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (_auth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }
}
