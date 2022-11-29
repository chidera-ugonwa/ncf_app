import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:myapp/screens/scripture/passage.dart';

typedef OnSearchChanged = Future<List<String>> Function(String);

class CustomSearchDelegate extends SearchDelegate {
  ///[onSearchChanged] gets the [query] as an argument. Then this callback
  ///should process [query] then return an [List<String>] as suggestions.
  ///Since its returns a [Future] you get suggestions from server too.
  final OnSearchChanged onSearchChanged;
  final dynamic bibleId;

  ///This [_oldFiltezrs] used to store the previous suggestions. While waiting
  ///for [onSearchChanged] to completed, [_oldFilters] are displayed.
  List<String>? _oldFilters = const [];

  CustomSearchDelegate(
      {String searchFieldLabel = '',
      required this.onSearchChanged,
      required this.bibleId})
      : super(searchFieldLabel: searchFieldLabel);

  ///
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        if (query.isNotEmpty) {
          close(context, query);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  List _verseList = [];
  bool isLoading = true;

  Future<dynamic> searchApi() async {
    Uri url = Uri.https('api.scripture.api.bible', 'v1/bibles/$bibleId/search',
        {"query": query, "limit": "200"});
    Map<String, String> headers = {
      'Accept': 'application/json',
      'api-key': 'e5fdfb4832ce8bd21887678218788c84'
    };
    Response response = await http.get(url, headers: headers);
    final jsonResponse = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = jsonResponse['data'];
      final verses = data['verses'];
      _verseList = verses;
      isLoading = false;
      return verses;
    } else {
      return response.statusCode;
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget buildResults(
    BuildContext context,
  ) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters",
            ),
          )
        ],
      );
    }
    return FutureBuilder<dynamic>(
        future: searchApi(),
        builder: (context, snapshot) {
          if (isLoading) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Center(child: CircularProgressIndicator())
                ]);
          }
          if (_verseList.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Center(
                  child: Text(
                    "No Results Found",
                  ),
                )
              ],
            );
          } else {
            return ListView.builder(
                itemCount: _verseList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      onTap: () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Passage(
                              bibleId: _verseList[index]["bibleId"],
                              passageId: _verseList[index]["chapterId"]);
                        }));
                      },
                      leading: SizedBox(
                        width: 60,
                        child: Text(
                          _verseList[index]["reference"],
                          overflow: TextOverflow.visible,
                          maxLines: 4,
                          style: const TextStyle(
                              color: Colors.indigo, fontSize: 15),
                        ),
                      ),
                      title: Text(_verseList[index]["text"]));
                });
          }
        });
  }

//build search suggestions
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: onSearchChanged(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) _oldFilters = snapshot.data;
        return ListView.builder(
          itemCount: _oldFilters!.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.restore),
              title: Text(_oldFilters![index]),
              onTap: () {
                query = _oldFilters![index];
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}
