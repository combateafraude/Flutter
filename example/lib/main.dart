import 'package:document_detector_sdk/document_detector_sdk.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String result = '';
  Capture captureFront = Capture(imagePath: null, missedAttemps: null);
  Capture captureBack = Capture(imagePath: null, missedAttemps: null);
  SDKFailure sdkFailure = SDKFailure('');
  final mobileToken = 'mobileToken_here';

  @override
  void initState() {
    super.initState();

    requestPermissions();
  }

  void requestPermissions() async {
    await [
      Permission.camera,
      Permission.storage,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sample DocumentDetector Plugin'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 50,
                child: RaisedButton(
                    child: Text('Document Detector'),
                    onPressed: () async {
                      DocumentDetector documentDetector =
                          DocumentDetector.builder(
                              mobileToken: mobileToken,
                              documentType: DocumentType.CNH);

                      /*
                      documentDetector.setRequestTimeout(30);
                      documentDetector.setIOSColorTheme(Colors.blue);
                      documentDetector.setAndroidStyle("baseOneColor");
                      documentDetector.setAndroidLayout("activity_sdk");
                      documentDetector.setAndroidMask(
                          drawableGreenName: "ic_mask_document",
                          drawableRedName: "ic_mask_document",
                          drawableWhiteName: "ic_mask_document");
                      */

                      final documentResult = await documentDetector.build();

                      if (documentResult.sdkFailure == null) {
                        print(
                            'success: ${documentResult.captureFront.toString()}');
                        print(
                            'success: ${documentResult.captureBack.toString()}');
                        setState(() {
                          captureFront = documentResult.captureFront;
                          captureBack = documentResult.captureBack;
                        });
                      } else {
                        print(
                            'failed: ${documentResult.sdkFailure.toString()}');
                        setState(() {
                          sdkFailure = documentResult.sdkFailure;
                        });
                      }
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Results',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Image Front: ${captureFront.imagePath ?? ''}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Image Back: ${captureFront.imagePath ?? ''}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Error: ${sdkFailure.toString() ?? ''}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
