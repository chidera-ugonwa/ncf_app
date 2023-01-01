import 'package:flutter/material.dart';
import 'package:myapp/screens/scripture/books.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;

class Scripture extends StatefulWidget {
  const Scripture({Key? key}) : super(key: key);

  @override
  State<Scripture> createState() => _ScriptureState();
}

class _ScriptureState extends State<Scripture>
    with AutomaticKeepAliveClientMixin {
  List _bibleList = [];
  bool isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    getBibles();
    _bibleList;
    super.initState();
  }

  Future<List> getBibles() async {
    Uri url = Uri.https('api.scripture.api.bible', 'v1/bibles', {
      'language': 'eng',
    });
    Map<String, String> headers = {
      'Accept': 'application/json',
      'api-key': 'e5fdfb4832ce8bd21887678218788c84'
    };
    Response response = await http.get(url, headers: headers);
    final jsonResponse = convert.jsonDecode(response.body);
    final data = jsonResponse['data'];
    setState(() {
      _bibleList = data;
      isLoading = false;
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scripture"),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: _bibleList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        onTap: () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Books(
                                bibleId: _bibleList[index]["id"],
                                bibleAbbrv: _bibleList[index]["abbreviation"]);
                          }));
                        },
                        leading: const Icon(Icons.list),
                        trailing: Text(
                          _bibleList[index]["abbreviation"],
                          style: const TextStyle(
                              color: Colors.indigo, fontSize: 15),
                        ),
                        title: Text(_bibleList[index]["name"]));
                  }),
        ),
      ),
    );
  }
}
