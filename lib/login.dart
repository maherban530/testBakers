import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:interview_bakers/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Login to your account"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: buildEmailFormField(),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: buildPasswordFormField(),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    child: Text("Sign In"),
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
                    "RegisterNow",
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: (15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
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
}
