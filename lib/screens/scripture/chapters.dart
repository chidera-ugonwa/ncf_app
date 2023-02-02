import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:myapp/screens/scripture/passage.dart';

class Chapters extends StatefulWidget {
  const Chapters({Key? key, this.bibleId, this.bookId}) : super(key: key);
  final dynamic bibleId;
  final dynamic bookId;

  @override
  _ChaptersState createState() => _ChaptersState();
}

class _ChaptersState extends State<Chapters> {
  List _chapterList = [];
  bool isLoading = true;

  @override
  void initState() {
    getChapters();
    super.initState();
  }

  //Function to get chapters
  Future<List> getChapters() async {
    Uri url = Uri.https('api.scripture.api.bible',
        'v1/bibles/${widget.bibleId}/books/${widget.bookId}/chapters');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'api-key': 'e5fdfb4832ce8bd21887678218788c84'
    };
    Response response = await http.get(url, headers: headers);
    final jsonResponse = convert.jsonDecode(response.body);
    final data = jsonResponse['data'];
    setState(() {
      _chapterList = data;
      isLoading = false;
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookId),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1,
                            crossAxisCount: 6,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemCount: _chapterList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Passage(
                                bibleId: _chapterList[index]["bibleId"],
                                passageId: _chapterList[index]["id"]);
                          }));
                        },
                        child: GridTile(
                            child: Container(
                                height: 5,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue)),
                                child: Center(
                                    child:
                                        Text(_chapterList[index]["number"])))),
                      );
                    }),
          ),
        ),
      ),
    );
  }
}
