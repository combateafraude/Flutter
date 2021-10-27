import 'package:face_authenticator/face_authenticator.dart';
import 'package:face_authenticator/ios/settings.dart';
import 'package:face_authenticator/result/face_authenticator_failure.dart';
import 'package:face_authenticator/result/face_authenticator_result.dart';
import 'package:face_authenticator/result/face_authenticator_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = "";
  String _description = "";

  String mobileToken = "";
  String peopleId = "";

  @override
  void initState() {
    super.initState();

    requestPermissions();
  }

  void requestPermissions() async {
    await [
      Permission.camera,
    ].request();
  }

  void startFaceAuthenticator() async {
    String result = "";
    String description = "";

    FaceAuthenticator faceAuthenticator =
        new FaceAuthenticator(mobileToken: mobileToken);


    faceAuthenticator.setPeopleId(peopleId);

    FaceAuthenticatorIosSettings iosSettings = new FaceAuthenticatorIosSettings(
      enableManualCapture: true,
      manualCaptureTime: 10
    );

    faceAuthenticator.setIosSettings(iosSettings);

    // Put the others parameters here

    try {
      FaceAuthenticatorResult faceAuthenticatorResult =
          await faceAuthenticator.start();

      if (faceAuthenticatorResult is FaceAuthenticatorSuccess) {
        result = "Success!";

        description += "\n\tauthenticated: " +
            (faceAuthenticatorResult.authenticated ? "true" : "false") +
            "\n\tsignedResponse: " +
            (faceAuthenticatorResult.signedResponse != null
                ? faceAuthenticatorResult.signedResponse
                : "null");
      } else if (faceAuthenticatorResult is FaceAuthenticatorFailure) {
        result = "Falha!";
        description = "\tType: " +
            faceAuthenticatorResult.type +
            "\n\tMessage: " +
            faceAuthenticatorResult.message;
      } else {
        result = "Closed!";
      }
    } on PlatformException catch (err) {
      result = "Excpection!";
      description = err.message;
    }

    if (!mounted) return;

    setState(() {
      _result = result;
      _description = description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('FaceAuthenticator plugin example'),
            ),
            body: Container(
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        RaisedButton(
                          child: Text('Start FaceAuthenticator'),
                          onPressed: () async {
                            startFaceAuthenticator();
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text("Result: $_result"))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text("Description:\n$_description",
                              overflow: TextOverflow.clip),
                        )
                      ],
                    ),
                  ],
                ))));
  }
}
