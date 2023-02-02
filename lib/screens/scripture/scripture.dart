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
      'ids':
          '685d1470fe4d5c3b-01,bba9f40183526463-01,55212e3cf5d04d49-01,179568874c45066f-01,55ec700d9e0d77ea-01,65eec8e0b60e656b-01,c315fa9f71d4af3a-01,de4e12af7f28f599-01,01b29f4b342acc35-01,40072c4a5aba4022-01,06125adad2d5898a-01,66c22495370cdfc0-01,9879dbb7cfe39e4d-01,f72b840c855f362c-04'
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
        title: const Text("Versions"),
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
