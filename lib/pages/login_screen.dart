import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototipo/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? mailSalvo = "";
  TextEditingController mailController = TextEditingController();
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      _auth.signOut();
    }
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
                  controller: mailController,
                  decoration: InputDecoration(
                    hintText: "E-mail",
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: TextFormField(
                        validator: (text) {
                          if (text!.isEmpty) return "Preencha a senha!";
                        },
                        onChanged: (txt) {
                          senha = txt;
                        },
                        decoration: InputDecoration(
                          hintText: "Senha",
                        ),
                        obscureText: isChecked,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: IconButton(
                          onPressed: () {
                            setState(
                              () {
                                isChecked = !isChecked;
                              },
                            );
                          },
                          color: Colors.black.withOpacity(0.4),
                          icon: Icon(isChecked ? Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ],
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
                          savePrefs(email);
                          print(email);
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

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  Future<void> savePrefs(String s) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('mail', s);
  }

  Future<void> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      print(prefs.getString('mail'));
      mailSalvo = prefs.getString('mail') ?? "";
      email = mailSalvo!;
      mailController.text = mailSalvo!;
    });
  }

  void verificaSeEstaLogado() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (_auth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }
}
