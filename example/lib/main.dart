import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:flutter/material.dart';
import 'package:new_face_authenticator_compatible/caf_stage.dart';
import 'package:new_face_authenticator_compatible/camera_filter.dart';
import 'package:new_face_authenticator_compatible/face_authenticator.dart';
import 'package:new_face_authenticator_compatible/face_authenticator_events.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _scanInProgress = false;

  String _result = "";
  String _description = "";

  String mobileToken = "";
  String personId = "";

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

  void startFaceAuth() {
    setState(() => _scanInProgress = true);
    ProgressHud.show(ProgressHudType.loading, 'Launching SDK');

    String result = "";
    String description = "";

    FaceAuthenticator faceAuth =
        FaceAuthenticator(mobileToken: mobileToken, personId: personId);

    faceAuth.setStage(CafStage.prod);
    faceAuth.setCameraFilter(CameraFilter.natural);

    // Put the others parameters here

    final stream = faceAuth.start();

    stream.listen((event) {
      if (event.isFinal) {
        setState(() => _scanInProgress = false);
      }

      if (event is FaceAuthenticatorEventConnecting) {
        ProgressHud.show(ProgressHudType.loading, 'Loading...');
      } else if (event is FaceAuthenticatorEventConnected) {
        ProgressHud.dismiss();
      } else if (event is FaceAuthenticatorEventClosed) {
        ProgressHud.dismiss();
        print('Canceled\nUsuário fechou o SDK');
      } else if (event is FaceAuthenticatorEventSuccess) {
        ProgressHud.showAndDismiss(ProgressHudType.success, 'Success!');
        print('Success!\nSignedResponse: ${event.signedResponse}');
      } else if (event is FaceAuthenticatorEventFailure) {
        ProgressHud.showAndDismiss(ProgressHudType.error, event.errorMessage);
        print(
            'Failure!\nError type: ${event.errorType} \nError Message: ${event.errorMessage} \nError code: ${event.code} \nResponse:${event.signedResponse}');
      }
    });

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
            body: ProgressHud(
                isGlobalHud: true,
                child: Container(
                    margin: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ElevatedButton(
                              child: Text('Start FaceAuth'),
                              onPressed: _scanInProgress
                                  ? null
                                  : () {
                                      startFaceAuth();
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
                    )))));
  }
}
