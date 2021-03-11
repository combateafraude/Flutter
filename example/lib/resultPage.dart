import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultPage extends StatefulWidget {
  final String userId;
  final String mobileToken;

  ResultPage(this.userId, this.mobileToken);

  @override
  ResultState createState() => ResultState();
}

class ResultState extends State<ResultPage> {
  @override
  String last_activity_ts;
  String _correlation = "Aperte no botão para fazer a requisição de score";
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.all(20.0),
            child: ListView(children: <Widget>[
              Text(_correlation, textAlign: TextAlign.center),
              ElevatedButton(
                child: Text('Atualizar', textAlign: TextAlign.center),
                onPressed: () async {
                    setState(() {
                      _correlation = 'Carregando...';
                    });
                    var response = await http.get(
                        Uri.encodeFull(
                            "https://api.mobile.combateafraude.com/address/"+ widget.userId),
                        //+ widget.userId),
                        headers: {
                          "Authorization":
                          widget.mobileToken
                        });
                    final Map<String, dynamic> responseMap = json.decode(response.body);
                    setState(() {
                      if(response.statusCode == 200)
                        _correlation =
                          json.decode(response.body)["address_verification"][0]
                              ["correlation"];
                    });
                },
              ),
            ])));
  }
}
