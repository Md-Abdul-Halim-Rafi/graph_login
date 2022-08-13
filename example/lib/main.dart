import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:graph_login/graph_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _login() async {
    GraphLogin _plugin = GraphLogin(appId: "APP-ID-1", debug: true);

    var res = await _plugin.logIn(
        permissions: [GraphPermission.email, GraphPermission.publicProfile]);

    log(res.accessToken!.token, name: "DEFAULT");
  }

  Future<void> _changeAppID() async {
    GraphLogin _graphLogin = GraphLogin(appId: "APP-ID-2", debug: true);

    var res = await _graphLogin.logIn(
        permissions: [GraphPermission.email, GraphPermission.publicProfile]);

    log(res.accessToken!.token, name: "PAGE");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Example Graph Login"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text("Default App ID & Login"),
                onPressed: _login,
              ),
              ElevatedButton(
                child: const Text("Change App ID & Login"),
                onPressed: _changeAppID,
              )
            ],
          ),
        ),
      ),
    );
  }
}
