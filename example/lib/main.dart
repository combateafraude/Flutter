import 'package:new_face_authenticator/caf_stage.dart';
import 'package:new_face_authenticator/camera_filter.dart';
import 'package:new_face_authenticator/face_authenticator.dart';
import 'package:new_face_authenticator/result/face_authenticator_closed.dart';
import 'package:new_face_authenticator/result/face_authenticator_failure.dart';
import 'package:new_face_authenticator/result/face_authenticator_result.dart';
import 'package:new_face_authenticator/result/face_authenticator_success.dart';
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
        FaceAuthenticator(mobileToken: mobileToken, personId: peopleId);

    faceAuthenticator.setStage(CafStage.PROD);

    faceAuthenticator.setCameraFilter(CameraFilter.NATURAL);

    faceAuthenticator.setEnableScreenshots(true);

    try {
      FaceAuthenticatorResult faceAuthenticatorResult =
          await faceAuthenticator.start();

      if (faceAuthenticatorResult is FaceAuthenticatorSuccess) {
        result = "Success!";
        description =
            "authenticated: ${faceAuthenticatorResult.signedResponse}";
      } else if (faceAuthenticatorResult is FaceAuthenticatorFailure) {
        result = "Falha!";
        description =
            "Error Type: ${faceAuthenticatorResult.errorType} \nError Message: ${faceAuthenticatorResult.errorMessage} \nCode: ${faceAuthenticatorResult.code} \nSignRes: ${faceAuthenticatorResult.signedResponse}";
      } else if (faceAuthenticatorResult is FaceAuthenticatorClosed) {
        result = "Usuário fechou!";
      }
    } on PlatformException catch (err) {
      result = "Excpection!";
      description = err.message!;
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
                        ElevatedButton(
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
