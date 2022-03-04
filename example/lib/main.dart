import 'package:passive_face_liveness/android/image_capture.dart';
import 'package:passive_face_liveness/android/settings.dart';
import 'package:passive_face_liveness/android/video_capture.dart';
import 'package:passive_face_liveness/ios/ios_resolution.dart';
import 'package:passive_face_liveness/ios/settings.dart';
import 'package:passive_face_liveness/show_preview.dart';
import 'package:flutter/material.dart';
import 'package:passive_face_liveness/passive_face_liveness.dart';
import 'package:passive_face_liveness/message_settings.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_failure.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_result.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_success.dart';
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

  void startPassiveFaceLiveness() async {
    String result = "";
    String description = "";

    https://mobile-prod-liveness-attempts.s3.amazonaws.com/35c8ac41-b556-4b90-a631-36b75ce7b597/not_identified/liveness/attempt_1646421617562.jpg?AWSAccessKeyId=ASIAS6F2XPA7QBS4MYYO&Expires=1646421918&Signature=E3Pk4NvR4rb4r%2BmpbDgAJ9YaDf8%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEPz%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJIMEYCIQDAdth2UKpk%2B8nHd%2FFpSiSebQOXXw2yemf3DVxzKtArlAIhAJREm%2Bx6ekH3ftZi%2B1iRJZCCF%2BrQYUb5atjG7KBh1fQdKqECCGQQAhoMMjAyMjU1MDcxMjk1IgwKfidj%2BTsfiGkGeygq%2FgF6XoL7HkI3LkCV3nDkjbXqbDGcjl6MEKUauSDVLMDZ7O1UhDDOKK3yyxtJcON0YDARqbFv5%2FhOlte%2Fn0pCsf78Ip3BFLKk3hG4jAGOZ4HD06Ue8dmiIsDgcdHIK0J1IfK8iUaeHPR8Nw%2FMZl5l75fbTZcQA8XtjavlyjX42xn67aC1neBaEzvoagv9iATstRVw1U0a8gQXk9Uep3d92XvWDUzmwq%2F%2Bv5kro1SHHky7vmiidA97OJRjb44s4%2F8rl6XQM1%2FCxSTOQAh73BMlgBkmw2Rh2ZIz3D%2FyEAnA%2B%2FKZw49DXr5838hRhfZ8hQiJkSZP6DKL0VDJIGgTTdXqFjCLyomRBjqZAeKj4jogG1fELPVJ4abW3D2X7SszyBH26Mpd9zYodEDwNSxh46Rr%2FYrKlxFXn3BugO9GkjE94eHj%2FuA2U6mnY1Winvom1AL4p6bdwZnt6JhgcGGWq8%2FGsoAbEvrHmkDvRZ8J7AR6TiBInIsBk5H1naq7GuCdWmTNPTsystjLzpVAaRa4GIYP9QvHiO8DXuh8IdLZeTVSB957Rw%3D%3D

    PassiveFaceLiveness passiveFaceLiveness =
        new PassiveFaceLiveness(mobileToken: mobileToken);

    PassiveFaceLivenessAndroidSettings passiveFaceLivenessAndroidSettings =
        new PassiveFaceLivenessAndroidSettings(
            showButtonTime: 25000, enableSwitchCameraButton: true);

    passiveFaceLiveness.setCaptureMode(imageCapture: ImageCapture(use: true));

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
                        RaisedButton(
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
