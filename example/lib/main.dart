import 'package:activeface_liveness_sdk/activeface_liveness_sdk.dart';
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
  ActiveFaceLivenessResult activeFaceLivenessResult =
      ActiveFaceLivenessResult();
  final mobileToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI1ZTg2MjAxNGVjMjFjNDAwMDgxYjY2NmQifQ.9bf3VPzAwHd7IMS9ZzAUaguhe0OKu2mHxCjddQgboVE';

  @override
  void initState() {
    super.initState();

    requestPermissions();
  }

  void requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sample ActiveFaceLiveness Plugin'),
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
                    child: Text('ActiveFaceLiveness'),
                    onPressed: () async {
                      ActivefaceLiveness activeFaceLiveness =
                          ActivefaceLiveness.builder(mobileToken: mobileToken);
                      /*
                      activeFaceLiveness.setNumberOfSteps(3);
                      activeFaceLiveness.setActionTimeout(10);
                      activeFaceLiveness.setRequestTimeout(30);

                      activeFaceLiveness.setIOSColorTheme(Colors.blue);
                      activeFaceLiveness.setAndroidStyle("baseOneColor");
                      activeFaceLiveness.setAndroidLayout("activity_sdk");
                      activeFaceLiveness.setAndroidMask(
                          drawableGreenName: "ic_mask_document",
                          drawableWhiteName: "ic_mask_document",
                          drawableRedName: "ic_mask_document");
                      */
                      activeFaceLivenessResult =
                          await activeFaceLiveness.build();

                      if (activeFaceLivenessResult.sdkFailure == null) {
                        print('success: ${activeFaceLivenessResult.imagePath}');
                        print(
                            'success: ${activeFaceLivenessResult.missedAttemps}');
                      } else {
                        print(
                            'failed: ${activeFaceLivenessResult.sdkFailure.toString()}');
                      }
                      setState(() {
                        result = activeFaceLivenessResult.toString();
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
                'Image : ${activeFaceLivenessResult.imagePath ?? ''}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Error: ${activeFaceLivenessResult.sdkFailure ?? ''}',
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
