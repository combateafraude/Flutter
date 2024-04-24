import 'package:document_detector/android/android_settings.dart';
import 'package:document_detector/caf_stage.dart';
import 'package:document_detector/document_detector_step.dart';
import 'package:document_detector/document_type.dart';
import 'package:document_detector/ios/ios_settings.dart';
import 'package:document_detector/result/capture.dart';
import 'package:document_detector/result/document_detector_failure.dart';
import 'package:document_detector/result/document_detector_result.dart';
import 'package:document_detector/result/document_detector_success.dart';
import 'package:document_detector/upload_settings.dart';

import 'package:flutter/material.dart';

import 'package:document_detector/document_detector.dart';
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

    DocumentDetectorIosSettings iosSettings = new DocumentDetectorIosSettings(
        enableManualCapture: true, timeEnableManualCapture: 15000);

    DocumentDetectorAndroidSettings androidSettings =
        new DocumentDetectorAndroidSettings(
            useAdb: true, useDebug: true, useDeveloperMode: true);

    documentDetector.setIosSettings(iosSettings);

    documentDetector.setStage(CafStage.BETA);

    documentDetector.setDocumentFlow(documentSteps);

    documentDetector.setAndroidSettings(androidSettings);

    // Put the others parameters here

    try {
      DocumentDetectorResult documentDetectorResult =
          await documentDetector.start();

      if (documentDetectorResult is DocumentDetectorSuccess) {
        result = "Success!";
        description = "Type: " +
            (documentDetectorResult.type != null
                ? documentDetectorResult.type!
                : "null");
        for (Capture capture in documentDetectorResult.captures) {
          description += "\n\n\tCapture:\n\timagePath: " +
              capture.imagePath! +
              "\n\timageUrl: " +
              (capture.imageUrl != null
                  ? capture.imageUrl!.split("?")[0] + "..."
                  : "null") +
              "\n\tlabel: " +
              (capture.label != null ? capture.label! : "null") +
              "\n\tquality: " +
              (capture.quality != null ? capture.quality.toString() : "null");
        }
      } else if (documentDetectorResult is DocumentDetectorFailure) {
        result = "Falha!";
        description = "\tType: " +
            documentDetectorResult.type! +
            "\n\tMessage: " +
            documentDetectorResult.message!;
      } else {
        result = "Closed!";
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

  void startDocumentDetectorUploadFlow(
      List<DocumentDetectorStep> documentSteps) async {
    String result = "";
    String description = "";

    DocumentDetector documentDetector =
        new DocumentDetector(mobileToken: mobileToken);

    DocumentDetectorAndroidSettings androidSettings =
        new DocumentDetectorAndroidSettings(
            useAdb: true, useDebug: true, useDeveloperMode: true);

    documentDetector.setUploadSettings(UploadSettings());

    documentDetector.setStage(CafStage.BETA);

    documentDetector.setDocumentFlow(documentSteps);

    documentDetector.setAndroidSettings(androidSettings);

    // Put the others parameters here

    try {
      DocumentDetectorResult documentDetectorResult =
          await documentDetector.start();

      if (documentDetectorResult is DocumentDetectorSuccess) {
        result = "Success!";
        description = "Type: " +
            (documentDetectorResult.type != null
                ? documentDetectorResult.type!
                : "null");
        for (Capture capture in documentDetectorResult.captures) {
          description += "\n\n\tCapture:\n\timagePath: " +
              capture.imagePath! +
              "\n\timageUrl: " +
              (capture.imageUrl != null
                  ? capture.imageUrl!.split("?")[0] + "..."
                  : "null") +
              "\n\tlabel: " +
              (capture.label != null ? capture.label! : "null") +
              "\n\tquality: " +
              (capture.quality != null ? capture.quality.toString() : "null");
        }
      } else if (documentDetectorResult is DocumentDetectorFailure) {
        result = "Falha!";
        description = "\tType: " +
            documentDetectorResult.type! +
            "\n\tMessage: " +
            documentDetectorResult.message!;
      } else {
        result = "Closed!";
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
              title: const Text('DocumentDetector SDK Flutter'),
            ),
            body: Container(
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          child: Text('DocumentDetector for CNH'),
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
                          child: Text('DocumentDetector for RG'),
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
                          child: Text('UploadFlow for CNH FULL'),
                          onPressed: () async {
                            startDocumentDetectorUploadFlow([
                              new DocumentDetectorStep(
                                  document: DocumentType.CNH_FULL)
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
