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
  List<Capture> capture = [];
  Capture captureFront =
      Capture(imagePath: null, missedAttemps: null, scannedLabel: null);
  Capture captureBack =
      Capture(imagePath: null, missedAttemps: null, scannedLabel: null);
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
                              flow: DocumentDetector.CNH_FLOW
                              //flow: [
                              //DocumentDetectorStep(
                              //    document: DocumentType.CNH_FRONT,
                              //    iosAudioName: "generic")]
                              );
                      // Custom flow
                      /*
                      DocumentDetector documentDetector = DocumentDetector
                          .builder(mobileToken: mobileToken, flow: [
                        DocumentDetectorStep(document: DocumentType.CNH_FRONT)
                      ]);

                      DocumentDetector documentDetector =
                          DocumentDetector.builder(
                              mobileToken: mobileToken,
                              flow: [
                            DocumentDetectorStep(
                              document: DocumentType.CNH_FULL,
                              //androidStepLabelName: 'stepLabel',
                              //androidNotFoundMsgName: 'notFoundMessage',
                              //androidIllustrationName: "generic",
                              //androidAudioName: "generic"
                            ),
                            DocumentDetectorStep(
                              document: DocumentType.RG_FULL,
                              //androidStepLabelName: 'stepLabel',
                              //androidNotFoundMsgName: 'notFoundMessage',
                              //androidIllustrationName: "generic",
                              //androidAudioName: "generic"
                            )
                          ]);
                       */

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
                      documentDetector.setIOSSLayout(DocumentDetectorLayout(
                          closeImageName: "close",
                          soundOnImageName: "sound_on",
                          soundOffImageName: "sound_off",
                          greenMaskImageName: "green_mask",
                          redMaskImageName: "red_mask",
                          whiteMaskImageName: "white_mask"));
                      documentDetector.uploadImages(
                          upload: true, imageQuality: 50);
                      documentDetector.showPopup(false);

                      documentDetector.uploadImages(
                          upload: true, imageQuality: 50);

                      documentDetector.setAndroidSensorSettings(
                          luminosityMessageName: 'luminosityMessage',
                          orientationMessageName: 'orientationMessage',
                          stabilityMessageName: 'stabilityMessage');

                      documentDetector.setIOSSensorSettings(
                          luminosityMessage: 'luminosityMessage',
                          orientationMessage: 'orientationMessage',
                          stabilityMessage: 'stabilityMessage');
                       */

                      documentDetector.setIOSColorTheme(Colors.blue);
                      final documentResult = await documentDetector.build();

                      if (documentResult.wasSuccessful) {
                        if (documentResult.capture.length == 2) {
                          print('success: ${documentResult.toString()}');

                          print(
                              'success: ${documentResult.captureFront.toString()}');
                          print(
                              'success: ${documentResult.captureBack.toString()}');
                          setState(() {
                            type = documentResult.type;
                            captureFront = documentResult.captureFront;
                            captureBack = documentResult.captureBack;
                            capture = documentResult.capture;
                            sdkFailure = null;
                          });
                        } else {
                          setState(() {
                            captureFront = Capture(
                                imagePath: null,
                                missedAttemps: null,
                                scannedLabel: null);
                            captureBack = Capture(
                                imagePath: null,
                                missedAttemps: null,
                                scannedLabel: null);
                            capture = documentResult.capture;
                            sdkFailure = null;
                          });
                        }
                      } else {
                        print(
                            'failed: ${documentResult.sdkFailure.toString()}');
                        setState(() {
                          type = null;
                          captureFront = Capture(
                              imagePath: null,
                              missedAttemps: null,
                              scannedLabel: null);
                          captureBack = Capture(
                              imagePath: null,
                              missedAttemps: null,
                              scannedLabel: null);
                          sdkFailure = documentResult.sdkFailure;
                        });
                      }
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Results : ${capture.length} ',
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
              Divider(),
              Text(
                'List<Capture>',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              for (var i = 0; i < capture.length; ++i)
                Text(
                  'Capture $i: imagePath: ${capture[i].imagePath ?? ''}',
                  style: TextStyle(color: Colors.black),
                ),
              Divider(),
              SizedBox(
                height: 4,
              ),
              Text(
                'Only CNH_FLOW / RG_FLOW',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
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
              Divider(),
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
