import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;

class Passage extends StatefulWidget {
  const Passage({Key? key, this.bibleId, this.passageId}) : super(key: key);
  final dynamic bibleId;
  final dynamic passageId;

  @override
  _PassageState createState() => _PassageState();
}

class _PassageState extends State<Passage> {
//variable to store the passage data
  Map _passageMap = {};
  bool isLoading = true;

  @override
  void initState() {
    getPassage();
    super.initState();
  }

  //Function to get passages
  Future<Map> getPassage() async {
    Uri url = Uri.https(
        'api.scripture.api.bible',
        'v1/bibles/${widget.bibleId}/chapters/${widget.passageId}',
        {"content-type": "text"});
    Map<String, String> headers = {
      'Accept': 'application/json',
      'api-key': 'e5fdfb4832ce8bd21887678218788c84'
    };
    Response response = await http.get(url, headers: headers);
    final jsonResponse = convert.jsonDecode(response.body);
    final data = jsonResponse['data'];
    setState(() {
      _passageMap = data;
      isLoading = false;
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.passageId),
          backgroundColor: Colors.blue[800],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                    child: SelectableText(_passageMap["content"].toString())),
              ));
  }
}
