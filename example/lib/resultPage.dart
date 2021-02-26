import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultPage extends StatefulWidget {
  final String userId;

  ResultPage(this.userId);

  @override
  ResultState createState() => ResultState();
}

class ResultState extends State<ResultPage> {
  @override
  String last_activity_ts;
  String _correlation = "teste";
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.all(20.0),
            child: ListView(children: <Widget>[
              Text(_correlation),
              ElevatedButton(
                child: Text('Update Result'),
                onPressed: () async {
                    var response = await http.get(
                        Uri.encodeFull(
                            "https://api.dev.mobile.combateafraude.com/address/02801389030"),
                        //+ widget.userId),
                        headers: {
                          "Authorization":
                              ""
                        });
                    final Map<String, dynamic> responseMap = json.decode(response.body);
                    setState(() {
                      _correlation =
                          json.decode(response.body)["address_verification"][0]
                              ["correlation"];
                    });
                },
              ),
            ])));
  }
}
