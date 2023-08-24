import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_basic_layout/controller/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();
    UserService userService = context.watch<UserService>();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fhở Bò',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Center(
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: 200,
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Log into Facebook',
                        style: TextStyle(fontSize: 20)),
                    TextField(
                      controller: email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      onSubmitted: (value) {
                        if (email.text != "" && password.text != "") {
                          userService.logIn(email.text, password.text);
                        }
                      },
                    ),
                    TextField(
                      controller: password,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSubmitted: (value) {
                        if (email.text != "" && password.text != "") {
                          userService.logIn(email.text, password.text);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            userService.logIn(email.text, password.text);
                          },
                          child: const Text('Log in')),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
