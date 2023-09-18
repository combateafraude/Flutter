import 'package:flutter/material.dart';
import 'package:new_face_liveness_compatible/camera_filter.dart';
import 'package:new_face_liveness_compatible/caf_stage.dart';
import 'package:new_face_liveness_compatible/passive_face_liveness.dart';
import 'package:new_face_liveness_compatible/result/passive_face_liveness_closed.dart';
import 'package:new_face_liveness_compatible/result/passive_face_liveness_failure.dart';
import 'package:new_face_liveness_compatible/result/passive_face_liveness_result.dart';
import 'package:new_face_liveness_compatible/result/passive_face_liveness_success.dart';

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

  void startPassiveFaceLiveness() async {
    String result = "";
    String description = "";

    PassiveFaceLiveness passiveFaceLiveness =
        new PassiveFaceLiveness(mobileToken: mobileToken, peopleId: peopleId);

    passiveFaceLiveness.setStage(CafStage.BETA);

    passiveFaceLiveness.setCameraFilter(CameraFilter.NATURAL);

    // Put the others parameters here

    PassiveFaceLivenessResult passiveFaceLivenessResult =
        await passiveFaceLiveness.start();

    if (passiveFaceLivenessResult is PassiveFaceLivenessSuccess) {
      result = "Success!";

      description +=
          "\n\signedResponse: " + passiveFaceLivenessResult.signedResponse;
    } else if (passiveFaceLivenessResult is PassiveFaceLivenessFailure) {
      result = "Falha!";
      description =
          "ErrorMessage: ${passiveFaceLivenessResult.errorMessage} \nErrorType: ${passiveFaceLivenessResult.errorType} \nCode: ${passiveFaceLivenessResult.code} \nResponse:${passiveFaceLivenessResult.signedResponse}";
    } else if (passiveFaceLivenessResult is PassiveFaceLivenessClosed) {
      result = "User closed!";
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
              title: const Text('PassiveFaceLiveness plugin example'),
            ),
            body: Container(
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          child: Text('Start PassiveFaceLiveness'),
                          onPressed: () async {
                            startPassiveFaceLiveness();
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
