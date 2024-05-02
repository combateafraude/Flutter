import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:flutter/material.dart';
import 'package:new_face_authenticator/caf_stage.dart';
import 'package:new_face_authenticator/camera_filter.dart';
import 'package:new_face_authenticator/face_authenticator.dart';
import 'package:new_face_authenticator/face_authenticator_events.dart';

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
  }

  void startFaceAuth() {
    setState(() {
      _scanInProgress = true;
      _result = "";
      _description = "";
    });
    ProgressHud.show(ProgressHudType.loading, 'Launching SDK');

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
        setState(() {
          _result = "Canceled";
          _description = "Usuário fechou o SDK";
        });
        print('Canceled\nUsuário fechou o SDK');
      } else if (event is FaceAuthenticatorEventSuccess) {
        ProgressHud.showAndDismiss(ProgressHudType.success, 'Success!');
        setState(() {
          _result = "Success";
          _description = "SignedResponse: ${event.signedResponse}";
        });
        print('Success!\nSignedResponse: ${event.signedResponse}');
      } else if (event is FaceAuthenticatorEventFailure) {
        ProgressHud.showAndDismiss(ProgressHudType.error, event.errorType!);
        setState(() {
          _result = "Failure";
          _description =
              "Error type: ${event.errorType} \nError Message: ${event.errorDescription}";
        });
        print(
            'Failure!\nError type: ${event.errorType} \nError Message: ${event.errorDescription}');
      }
    });

    if (!mounted) return;
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
                                  maxLines: 15,
                                  overflow: TextOverflow.ellipsis),
                            )
                          ],
                        ),
                      ],
                    )))));
  }
}
