import 'package:flutter/material.dart';
import 'package:passiveface_liveness_sdk/passiveface_liveness_sdk.dart';
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
  PassiveFaceLivenessResult passiveFaceLivenessResult =
      PassiveFaceLivenessResult();

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
          title: const Text('Sample PassiveFaceLiveness Plugin'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 50,
                child: RaisedButton(
                    child: Text('PassiveFaceLiveness'),
                    onPressed: () async {
                      PassiveFaceLiveness passiveFaceLiveness =
                          PassiveFaceLiveness.builder(mobileToken: mobileToken);

                      /*
                      //Opcional parameters:
                      passiveFaceLiveness.setAndroidMask(
                          drawableGreenName: "ic_mask_document",
                          drawableWhiteName: "ic_mask_document",
                          drawableRedName: "ic_mask_document");
                      passiveFaceLiveness.setAndroidLayout("activity_sdk");
                      passiveFaceLiveness.hasSound(true);
                      passiveFaceLiveness.setAndroidStyle("baseOneColor");
                      passiveFaceLiveness.setRequestTimeout(30);
                      passiveFaceLiveness.setIOSColorTheme(Color(0xc22a1e));
                      passiveFaceLiveness.setIOSSLayout(
                        PassiveFaceLivenessLayout(
                            closeImageName: "close",
                            soundOnImageName: "sound_on",
                            soundOffImageName: "sound_off",
                            greenMaskImageName: "green_mask",
                            redMaskImageName: "red_mask",
                            whiteMaskImageName: "white_mask"),
                      );
                      passiveFaceLiveness.hasSound(false);
                      passiveFaceLiveness.setIOSShowStatusLabel(false);
                      passiveFaceLiveness.setIOSShowStepLabel(false);
                       */

                      passiveFaceLivenessResult =
                          await passiveFaceLiveness.build();

                      if (passiveFaceLivenessResult.sdkFailure == null) {
                        print(
                            'success: ${passiveFaceLivenessResult.imagePath}');
                        print(
                            'success: ${passiveFaceLivenessResult.missedAttemps}');
                        print('success: ${passiveFaceLivenessResult.imageUrl}');
                        print(
                            'success: ${passiveFaceLivenessResult.signedResponse}');
                      } else {
                        print(
                            'failed: ${passiveFaceLivenessResult.sdkFailure.toString()}');
                      }
                      setState(() {
                        result = passiveFaceLivenessResult.toString();
                      });
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Results',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Image : ${passiveFaceLivenessResult.imagePath ?? ''}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Error: ${passiveFaceLivenessResult.sdkFailure ?? ''}',
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
