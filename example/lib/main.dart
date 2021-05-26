import 'package:passive_face_liveness/android/settings.dart';
import 'package:passive_face_liveness/show_preview.dart';
import 'package:flutter/material.dart';
import 'package:passive_face_liveness/passive_face_liveness.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_failure.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_result.dart';
import 'package:passive_face_liveness/result/passive_face_liveness_success.dart';
import 'package:permission_handler/permission_handler.dart';
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

  void startPassiveFaceLiveness() async {
    String result = "";
    String description = "";

    PassiveFaceLiveness passiveFaceLiveness =
        new PassiveFaceLiveness(mobileToken: mobileToken);

    ShowPreview showPreview = new ShowPreview(
        show: true,
        title: "A foto ficou boa?",
        subTitle: "confira",
        confirmLabel: "Sim, ficou boa!",
        retryLabel: "Tirar novamente");

    MessageSettings messageSettings = new MessageSettings(
      stepName: "Registro Facial",
      faceNotFoundMessage: "Não encontramos um rosto",
      faceTooFarMessage: "Aproxime seu rosto",
      faceTooCloseMessage: "Afaste seu rosto",
      faceNotFittedMessage: "Encaixe seu rosto",
      multipleFaceDetectedMessage: "Mais de um rosto detectado",
      verifyingLivenessMessage: "Verificando selfie...",
      holdItMessage: "Segure assim",
      invalidFaceMessage: "Ops, rosto inválido. Tente novamente"
    );

    PassiveFaceLivenessAndroidSettings passiveFaceLivenessAndroidSettings =
        new PassiveFaceLivenessAndroidSettings(showButtonTime: 25000);

    passiveFaceLiveness.setShowPreview(showPreview);

    passiveFaceLiveness.setAndroidSettings(passiveFaceLivenessAndroidSettings);

    passiveFaceLiveness.setMessageSettings(messageSettings);

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
