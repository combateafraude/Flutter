import 'dart:convert';

import 'package:face_liveness/face_liveness_result.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:face_liveness/face_liveness.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _faceLivenessResult = 'Unknown';
  Image? _selfie;
  final _faceLivenessPlugin = FaceLiveness("", "", "", "");

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String faceLivenessResult;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      FaceLivenessResult result = await _faceLivenessPlugin.start();
      String responseMessage = result.responseMessage ?? '';
      String image = result.image ?? '';
      _selfie = Image.memory(base64Decode(image));
      String sessionId = result.sessionId ?? '';

      faceLivenessResult =
          "responseMessage: $responseMessage\nsessionId: $sessionId";
    } on PlatformException {
      faceLivenessResult = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _faceLivenessResult = faceLivenessResult;
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
              Text('Result:\n $_faceLivenessResult\n'),
              const SizedBox(height: 20),
              if (_selfie != null) _selfie!
            ],
          ),
        ),
      ),
    );
  }
}
