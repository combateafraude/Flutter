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
  String type = '';
  Capture captureFront = Capture(imagePath: null, missedAttemps: null);
  Capture captureBack = Capture(imagePath: null, missedAttemps: null);
  SDKFailure sdkFailure = SDKFailure('');
  final mobileToken = 'mobileToken';

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
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 50,
                child: RaisedButton(
                    child: Text('Document Detector'),
                    onPressed: () async {
                      DocumentDetector documentDetector =
                          DocumentDetector.builder(
                              mobileToken: mobileToken,
                              documentType: DocumentType.CNH,
                              uploadImages: true);

                      //Opcional parameters:
                      /*
                      documentDetector.setAndroidMask(
                          drawableGreenName: "ic_mask_document",
                          drawableWhiteName: "ic_mask_document",
                          drawableRedName: "ic_mask_document");
                      documentDetector.setAndroidLayout("activity_sdk");
                      documentDetector.hasSound(true);
                      documentDetector.setAndroidStyle("baseOneColor");
                      documentDetector.setRequestTimeout(30);
                      documentDetector.setIOSColorTheme(Color(0xc22a1e));
                      documentDetector.setIOSShowStepLabel(false);
                      documentDetector.setIOSShowStatusLabel(false);
                      documentDetector.setIOSSLayout(
                        DocumentDetectorLayout(
                            closeImageName: "close",
                            soundOnImageName: "sound_on",
                            soundOffImageName: "sound_off",
                            greenMaskImageName: "green_mask",
                            redMaskImageName: "red_mask",
                            whiteMaskImageName: "white_mask"),
                      );
                       */

                      final documentResult = await documentDetector.build();

                      if (documentResult.wasSuccessful) {
                        print('success: ${documentResult.toString()}');

                        print(
                            'success: ${documentResult.captureFront.toString()}');
                        print(
                            'success: ${documentResult.captureBack.toString()}');
                        setState(() {
                          type = documentResult.type;
                          captureFront = documentResult.captureFront;
                          captureBack = documentResult.captureBack;
                          sdkFailure = null;
                        });
                      } else {
                        print(
                            'failed: ${documentResult.sdkFailure.toString()}');
                        setState(() {
                          type = null;
                          captureFront =
                              Capture(imagePath: null, missedAttemps: null);
                          captureBack =
                              Capture(imagePath: null, missedAttemps: null);
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
                'Type: ${type ?? ''}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Image Front - imagePath: ${captureFront.imagePath ?? ''}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Image Front - imageUrl: ${captureFront.imageUrl ?? ''}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Image Back - imagePath: ${captureBack.imagePath ?? ''}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Image Back - imageUrl: ${captureBack.imageUrl ?? ''}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Error: ${sdkFailure ?? ''}',
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
