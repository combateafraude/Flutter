import 'package:passive_face_liveness_compatible/android/image_capture.dart';
import 'package:passive_face_liveness_compatible/android/settings.dart';
import 'package:passive_face_liveness_compatible/android/video_capture.dart';
import 'package:passive_face_liveness_compatible/caf_stage.dart';
import 'package:passive_face_liveness_compatible/ios/ios_resolution.dart';
import 'package:passive_face_liveness_compatible/ios/settings.dart';
import 'package:passive_face_liveness_compatible/preview_settings.dart';
import 'package:passive_face_liveness_compatible/show_preview.dart';
import 'package:flutter/material.dart';
import 'package:passive_face_liveness_compatible/passive_face_liveness.dart';
import 'package:passive_face_liveness_compatible/message_settings.dart';
import 'package:passive_face_liveness_compatible/result/passive_face_liveness_failure.dart';
import 'package:passive_face_liveness_compatible/result/passive_face_liveness_result.dart';
import 'package:passive_face_liveness_compatible/result/passive_face_liveness_success.dart';
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
  String mobileToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI1ZmMxM2U5MDE2YTgxODAwMDczNzNlMWYifQ._jdY1z1N1dfaFIq88Qk0akEgOk-taH2OxoW3oT1eLl0";

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
        new PassiveFaceLiveness(mobileToken: mobileToken);

    PassiveFaceLivenessAndroidSettings passiveFaceLivenessAndroidSettings =
        new PassiveFaceLivenessAndroidSettings(
            manualCaptureTime: 25000, enableSwitchCameraButton: true);

    passiveFaceLiveness.setCaptureMode(imageCapture: ImageCapture(use: true));

    passiveFaceLiveness.setPreviewSettings(new PreviewSettings(show: true));

    PassiveFaceLivenessIosSettings iosSettings =
        new PassiveFaceLivenessIosSettings(
            resolution: IosResolution.HD1280x720, compressionQuality: 1);

    passiveFaceLiveness.setIosSettings(iosSettings);

    passiveFaceLiveness.setAndroidSettings(passiveFaceLivenessAndroidSettings);

    // Put the others parameters here

    PassiveFaceLivenessResult passiveFaceLivenessResult =
        await passiveFaceLiveness.start();

    if (passiveFaceLivenessResult is PassiveFaceLivenessSuccess) {
      result = "Success!";

      description += "\n\timagePath: " +
          passiveFaceLivenessResult.imagePath +
          "\n\timageUrl: " +
          (passiveFaceLivenessResult.imageUrl != null
              ? passiveFaceLivenessResult.imageUrl.split("?")[0] + "..."
              : "null") +
          "\n\tsignedResponse: " +
          (passiveFaceLivenessResult.signedResponse != null
              ? passiveFaceLivenessResult.signedResponse
              : "null");
    } else if (passiveFaceLivenessResult is PassiveFaceLivenessFailure) {
      result = "Falha!";
      description = "\tType: " +
          passiveFaceLivenessResult.type +
          "\n\tMessage: " +
          passiveFaceLivenessResult.message;
    } else {
      result = "Closed!";
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
