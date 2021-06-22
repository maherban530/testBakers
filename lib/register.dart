import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController conformpassword = new TextEditingController();

  bool _passwordVisible = false;
  bool _conformPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Create your account"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: buildEmailFormField(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: buildPasswordFormField(),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: buildConformPassFormField(),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    child: Text("Sign Up"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        var sessions = FlutterSession();
                        await sessions.set(
                          "sessiondata",
                          Random().nextInt(100000).toString(),
                        );
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        print("session ${prefs.getString('sessiondata')}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: (15)),
                  ),
                  TextButton(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: (15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a Email address';
        }
        if (!value.contains('@')) {
          return 'Email is invalid, must contain @';
        }
        if (!value.contains('.')) {
          return 'Email is invalid, must contain .';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "E-mail",
        hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: (15)),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: !_passwordVisible,
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a Password';
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: (15),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      controller: conformpassword,
      obscureText: !_conformPasswordVisible,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a Conform Password';
        }

        if (value.isNotEmpty &&
            passwordController.text != conformpassword.text) {
          return 'Conforme Password not match';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Confirm password",
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: (15),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _conformPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _conformPasswordVisible = !_conformPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}
