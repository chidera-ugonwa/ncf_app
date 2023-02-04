import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen>
    with AutomaticKeepAliveClientMixin {
  List items = [];
  bool isLoading = true;
  List<File> imageNames = [];
  List<String> urls = [];

  @override
  bool get wantKeepAlive => true;

  retry() {
    getListOfBooks();
  }

  getListOfBooks() async {
    try {
      await getImages();
      urls = await getDownloadUrls(imageNames);

      final storageRef = FirebaseStorage.instance.ref();

      final listResult = await storageRef.listAll();

      for (var item in listResult.items) {
        // debugPrint(item.name);
        items.add(item.name);
        setState(() => isLoading = false);
        //The items under storageRef.
      }
    } catch (e) {
      retry();
    }
  }

  Future<List> getImages() async {
    final storageRef = FirebaseStorage.instance.ref().child('images');

    final listResult = await storageRef.listAll();

    for (var item in listResult.items) {
      imageNames.add(File(item.name));
    }
    return imageNames;
  }

  static Future<String> getDownloadUrl(File _image) async {
    final storageReference =
        FirebaseStorage.instance.ref().child('images/${_image.path}');
    return await storageReference.getDownloadURL();
  }

  static Future<List<String>> getDownloadUrls(List<File> _images) async {
    var imageUrls =
        await Future.wait(_images.map((_image) => getDownloadUrl(_image)));
    //print(imageUrls);
    return imageUrls;
  }

  @override
  void initState() {
    super.initState();
    getListOfBooks();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    ItemTile(items[index], urls[index]),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                ),
              ));
  }
}

class ItemTile extends StatelessWidget {
  final String name;
  final String imageUrl;

  const ItemTile(this.name, this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Open Book'),
              content: Text('Do you want to open $name'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'NO'),
                  child: const Text('NO'),
                ),
                TextButton(
                  onPressed: () {
                    downloadFile();
                    Navigator.pop(context);
                  },
                  child: const Text('YES'),
                ),
              ],
            ),
          ),
          child: GridTile(
              child: Image.network(imageUrl,
                  fit: BoxFit.cover, height: 50, width: 50),
              footer: Container(
                  padding: const EdgeInsets.all(2.0),
                  color: Colors.white,
                  height: 60,
                  child:
                      Text(name, style: const TextStyle(color: Colors.black)))),
        ));
  }

  Future<void> downloadFile() async {
    final storageRef = FirebaseStorage.instance.ref();
    final islandRef = storageRef.child(name);

    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.path}/$name";

    final file = File(filePath);
    try {
      await islandRef.writeToFile(file);
      await file.create();
      await OpenFile.open(file.path);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
