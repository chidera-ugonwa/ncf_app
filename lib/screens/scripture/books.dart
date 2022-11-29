import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:myapp/screens/scripture/chapters.dart';
import 'package:myapp/screens/scripture/custom_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Books extends StatefulWidget {
  //
  const Books({Key? key, this.bibleId, this.bibleAbbrv}) : super(key: key);
  final dynamic bibleId;
  final dynamic bibleAbbrv;

  @override
  _BooksState createState() => _BooksState();
}

class _BooksState extends State<Books> {
  //
  List _bookList = [];
  bool isLoading = true;

  @override
  void initState() {
    getBooks();
    super.initState();
  }

  //Function to get books
  Future<List> getBooks() async {
    Uri url = Uri.https(
        'api.scripture.api.bible', 'v1/bibles/${widget.bibleId}/books');
    Map<String, String> headers = {
      'Accept': 'application/json',
      'api-key': 'e5fdfb4832ce8bd21887678218788c84'
    };
    Response response = await http.get(url, headers: headers);
    final jsonResponse = convert.jsonDecode(response.body);
    final data = jsonResponse['data'];
    setState(() {
      _bookList = data;
      isLoading = false;
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: Text(widget.bibleAbbrv),
          actions: [
            IconButton(
                onPressed: () {
                  _showSearch();
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : ListView.builder(
                    itemCount: _bookList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () async {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Chapters(
                                  bibleId: _bookList[index]["bibleId"],
                                  bookId: _bookList[index]["id"]);
                            }));
                          },
                          leading: const Icon(Icons.list),
                          trailing: Text(
                            _bookList[index]["abbreviation"],
                            style: const TextStyle(
                                color: Colors.indigo, fontSize: 15),
                          ),
                          title: Text(_bookList[index]["name"]));
                    }),
          ),
        ));
  }

//search widget
  Future<void> _showSearch() async {
    final searchText = await showSearch(
      context: context,
      delegate: CustomSearchDelegate(
          onSearchChanged: _getRecentSearchesLike, bibleId: widget.bibleId),
    );

    //Save the searchText to SharedPref so that next time you can use them as recent searches.
    await _saveToRecentSearches(searchText);

    //Do something with searchText. Note: This is not a result.
  }

  Future<List<String>> _getRecentSearchesLike(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentSearches");
    var results =
        allSearches!.where((search) => search.startsWith(query)).toList();
    results = allSearches.where((search) => search.isNotEmpty).toList();
    return results;
  }

  Future<void> _saveToRecentSearches(dynamic searchText) async {
    if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }
}
