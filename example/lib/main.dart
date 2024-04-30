import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:flutter/material.dart';
import 'package:new_face_liveness/caf_stage.dart';
import 'package:new_face_liveness/camera_filter.dart';
import 'package:new_face_liveness/face_liveness.dart';
import 'package:new_face_liveness/face_liveness_events.dart';

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

  void startFaceLiveness() {
    setState(() {
      _scanInProgress = true;
      _result = "";
      _description = "";
    });
    ProgressHud.show(ProgressHudType.loading, 'Launching SDK');

    FaceLiveness faceLiveness =
        FaceLiveness(mobileToken: mobileToken, personId: personId);

    faceLiveness.setStage(CafStage.beta);
    faceLiveness.setCameraFilter(CameraFilter.natural);

    // Put the others parameters here

    final stream = faceLiveness.start();

    stream.listen((event) {
      if (event.isFinal) {
        setState(() => _scanInProgress = false);
      }

      if (event is FaceLivenessEventConnecting) {
        ProgressHud.show(ProgressHudType.loading, 'Loading...');
      } else if (event is FaceLivenessEventConnected) {
        ProgressHud.dismiss();
      } else if (event is FaceLivenessEventClosed) {
        setState(() {
          _result = 'Canceled';
          _description = 'Usuário fechou o SDK';
        });
      } else if (event is FaceLivenessEventSuccess) {
        ProgressHud.showAndDismiss(ProgressHudType.success, 'Success!');
        setState(() {
          _result = 'Success!';
          _description = '\nSignedResponse: ${event.signedResponse}';
        });
        print(
            'SDK finished with Success! \nSignedResponse: ${event.signedResponse}');
      } else if (event is FaceLivenessEventFailure) {
        ProgressHud.showAndDismiss(ProgressHudType.error, event.errorType!);
        setState(() {
          _result = 'Failure!';
          _description =
              '\nError type: ${event.errorType} \nError Message: ${event.errorDescription}';
        });
        print(
            'SDK finished with Failure! \nError type: ${event.errorType} \nError Message: ${event.errorDescription}');
      }
    });

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('FaceLiveness plugin example'),
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
                              child: Text('Start PassiveFaceLiveness'),
                              onPressed: _scanInProgress
                                  ? null
                                  : () {
                                      startFaceLiveness();
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
