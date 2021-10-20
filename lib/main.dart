import 'package:document_detector/android/sensor_orientation_settings.dart';
import 'package:document_detector/android/sensor_settings.dart';
import 'package:document_detector/android/sensor_stability_settings.dart';
import 'package:flutter/material.dart';
import 'package:document_detector/android/android_settings.dart';
import 'package:document_detector/android/customization.dart';
import 'package:document_detector/android/maskType.dart';
import 'package:document_detector/android/resolution.dart';
import 'package:document_detector/message_settings.dart';
import 'package:document_detector/document_detector_step.dart';
import 'package:document_detector/document_type.dart';
import 'package:document_detector/ios/ios_settings.dart';
import 'package:document_detector/result/document_detector_result.dart';
import 'package:document_detector/document_detector.dart';
import 'package:passive_face_liveness/android/sensor_orientation_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:passive_face_liveness/android/settings.dart';
import 'package:passive_face_liveness/passive_face_liveness.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_failure.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_result.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_success.dart';
import 'package:passive_face_liveness/message_settings.dart';


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

  void startDocumentDetector(List<DocumentDetectorStep> documentSteps) async {
    DocumentDetector documentDetector =
        new DocumentDetector(mobileToken: mobileToken);

    documentDetector.setDocumentFlow(documentSteps);

    SensorOrientationSettingsAndroid orientationAndroid = new SensorOrientationSettingsAndroid(
      messageResourceIdName: "document_detector_orientation_message" //ROOT_PROJECT/android/app/src/main/res/values/strings.xml
    );

    SensorStabilitySettingsAndroid stabilitySettingsAndroid = new SensorStabilitySettingsAndroid(
      messageResourceIdName: "document_detector_stability_message" //ROOT_PROJECT/android/app/src/main/res/values/strings.xml
    );

    SensorSettingsAndroid sensorSettingsAndroid = new SensorSettingsAndroid(
      sensorOrientationSettings: orientationAndroid,
      sensorStabilitySettings: stabilitySettingsAndroid
    );

    DocumentDetectorAndroidSettings detectorAndroidSettings = new DocumentDetectorAndroidSettings(
            sensorSettings: sensorSettingsAndroid);

    documentDetector.setAndroidSettings(detectorAndroidSettings);

    DocumentDetectorResult documentDetectorResult = await documentDetector.start();

    if (!mounted) return;
  }

  void startPassiveFaceLiveness() async {
    PassiveFaceLiveness passiveFaceLiveness =
        new PassiveFaceLiveness(mobileToken: mobileToken);

    PassiveFaceLivenessResult passiveFaceLivenessResult =
        await passiveFaceLiveness.start();

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('iOS customization example'),
            ),
            body: Container(
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          child: Text('Start DocumentDetector for CNH'),
                          onPressed: () async {
                            startDocumentDetector([
                              new DocumentDetectorStep(
                                  document: DocumentType.CNH_FRONT),
                              new DocumentDetectorStep(
                                  document: DocumentType.CNH_BACK)
                            ]);
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          child: Text('Start DocumentDetector for RG'),
                          onPressed: () async {
                            startDocumentDetector([
                              new DocumentDetectorStep(
                                  document: DocumentType.RG_FRONT),
                              new DocumentDetectorStep(
                                  document: DocumentType.RG_BACK)
                            ]);
                          },
                        )
                      ],
                    ),
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
                  ],
                ))));
  }
}
