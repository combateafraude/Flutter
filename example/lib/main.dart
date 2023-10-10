import 'dart:ffi';

import 'package:face_authenticator_cs/face_authenticator_result.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:face_authenticator_cs/face_authenticator_cs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _faceAuthenticatorCsResult = 'Unknown';
  final _faceAuthenticatorCsPlugin = FaceAuthenticatorCs("", "", "", "");

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String faceAuthenticatorCsResult;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      FaceAuthenticatorCsResult result =
          await _faceAuthenticatorCsPlugin.start();

      bool isMatch = result.isMatch;
      bool isAlive = result.isAlive;
      String responseMessage = result.responseMessage ?? '';
      String sessionId = result.sessionId ?? '';

      faceAuthenticatorCsResult =
          "responseMessage: $responseMessage\nisMatch: $isMatch\nisAlive: $isAlive\nsessionId: $sessionId";
    } on PlatformException {
      faceAuthenticatorCsResult = 'Failed.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _faceAuthenticatorCsResult = faceAuthenticatorCsResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Result:\n $_faceAuthenticatorCsResult'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
