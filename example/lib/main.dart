import 'package:face_authenticator/face_authenticator.dart';
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
  FaceAuthenticatorResult faceAuthenticatorResult =
  FaceAuthenticatorResult();
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
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sample FaceAuthenticator Plugin'),
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
                    child: Text('FaceAuthenticator'),
                    onPressed: () async {
                      FaceAuthenticator faceAuthenticator = FaceAuthenticator.builder(mobileToken: mobileToken);
                      faceAuthenticator.setCpf("03073736069");
                      /*
                      faceAuthenticator.setRequestTimeout(30);

                      faceAuthenticator.setIOSColorTheme(Colors.blue);
                      faceAuthenticator.setAndroidStyle("baseOneColor");
                      faceAuthenticator.setAndroidLayout("activity_sdk");
                      faceAuthenticator.setAndroidMask(
                          drawableGreenName: "ic_mask_document",
                          drawableWhiteName: "ic_mask_document",
                          drawableRedName: "ic_mask_document");
                      */
                      faceAuthenticatorResult =
                          await faceAuthenticator.build();

                      if (faceAuthenticatorResult.sdkFailure == null) {
                        print('success: ${faceAuthenticatorResult.authenticated}');
                        print('success: ${faceAuthenticatorResult.signedResponse}');
                      } else {
                        print('failed: ${faceAuthenticatorResult.sdkFailure.toString()}');
                      }
                      setState(() {
                        result = faceAuthenticatorResult.toString();
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
                'Authenticated: ${faceAuthenticatorResult.authenticated ?? ''}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Error: ${faceAuthenticatorResult.sdkFailure ?? ''}',
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
