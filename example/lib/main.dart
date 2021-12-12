import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
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
  late GraphLogin _plugin;

  @override
  void initState() {
    super.initState();

    _plugin = GraphLogin(appId: "869831583747221", debug: true);

    _getSdk();
  }

  Future<void> _getSdk() async {

    final sdk = await _plugin.sdkVersion;
    print(sdk);
  }

  Future<void> _login() async {

    final sdk = await _plugin.sdkVersion;
    print(sdk);

    var res = await _plugin.logIn(
      permissions: [
        GraphPermission.email,
        GraphPermission.publicProfile
      ]
    );

    print(res.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Example Graph Login"),
        ),
        body: Center(
          child: ElevatedButton(
            child: const Text("Login"),
            onPressed: _login,
          ),
        ),
      ),
    );
  }
}
