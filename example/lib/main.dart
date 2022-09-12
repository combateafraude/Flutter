import 'package:document_detector_compatible/android/android_settings.dart';
import 'package:document_detector_compatible/android/capture_stage/capture_mode.dart';
import 'package:document_detector_compatible/android/capture_stage/capture_stage.dart';
import 'package:document_detector_compatible/android/customization.dart';
import 'package:document_detector_compatible/android/maskType.dart';
import 'package:document_detector_compatible/android/resolution.dart';
import 'package:document_detector_compatible/ios/ios_resolution.dart';
import 'package:document_detector_compatible/message_settings.dart';
import 'package:document_detector_compatible/show_preview.dart';
import 'package:document_detector_compatible/document_detector_step.dart';
import 'package:document_detector_compatible/document_type.dart';
import 'package:document_detector_compatible/ios/ios_settings.dart';
import 'package:document_detector_compatible/result/capture.dart';
import 'package:document_detector_compatible/result/document_detector_failure.dart';
import 'package:document_detector_compatible/result/document_detector_result.dart';
import 'package:document_detector_compatible/result/document_detector_success.dart';
import 'package:document_detector_compatible/upload_settings.dart';
import 'package:flutter/material.dart';

import 'package:document_detector_compatible/document_detector.dart';
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
    String result = "";
    String description = "";

    DocumentDetector documentDetector =
        new DocumentDetector(mobileToken: mobileToken);

    DocumentDetectorIosSettings documentDetectorIosSettings =
        new DocumentDetectorIosSettings(
            enableManualCapture: true, timeEnableManualCapture: 15000);

    DocumentDetectorAndroidSettings detectorAndroidSettings =
        new DocumentDetectorAndroidSettings(
            enableSwitchCameraButton: false,
            compressQuality: 50,
            resolution: Resolution.QUAD_HD);

    DocumentDetectorCustomizationAndroid documentDetectorCustomizationAndroid =
        new DocumentDetectorCustomizationAndroid(maskType: MaskType.DETAILED);

    MessageSettings messageSettings = new MessageSettings(
        openDocumentWrongMessage: "Feche o documento",
        showOpenDocumentMessage: true,
        unsupportedDocumentMessage: "Ops, esse documento não é suportado");

    DocumentDetectorIosSettings iosSettings = new DocumentDetectorIosSettings(
        resolution: IosResolution.HD1280x720, compressQuality: 1);

    List<String> formats = ["PDF", "PNG"];

    documentDetector.setIosSettings(iosSettings);

    documentDetector.setMessageSettings(messageSettings);

    documentDetector.setDocumentFlow(documentSteps);

    documentDetector.setAndroidSettings(detectorAndroidSettings);

    // Put the others parameters here

    try {
      DocumentDetectorResult documentDetectorResult =
          await documentDetector.start();

      if (documentDetectorResult is DocumentDetectorSuccess) {
        result = "Success!";
        description = "Type: " +
            (documentDetectorResult.type != null
                ? documentDetectorResult.type
                : "null");
        for (Capture capture in documentDetectorResult.captures) {
          description += "\n\n\tCapture:\n\timagePath: " +
              capture.imagePath +
              "\n\timageUrl: " +
              (capture.imageUrl != null
                  ? capture.imageUrl.split("?")[0] + "..."
                  : "null") +
              "\n\tlabel: " +
              (capture.label != null ? capture.label : "null") +
              "\n\tquality: " +
              (capture.quality != null ? capture.quality.toString() : "null");
        }
      } else if (documentDetectorResult is DocumentDetectorFailure) {
        result = "Falha!";
        description = "\tType: " +
            documentDetectorResult.type +
            "\n\tMessage: " +
            documentDetectorResult.message;
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
              title: const Text('DocumentDetector plugin example'),
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
                          child: Text('Start DocumentDetector for RNE'),
                          onPressed: () async {
                            startDocumentDetector([
                              new DocumentDetectorStep(
                                  document: DocumentType.RNE_FRONT),
                              new DocumentDetectorStep(
                                  document: DocumentType.RNE_BACK)
                            ]);
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
