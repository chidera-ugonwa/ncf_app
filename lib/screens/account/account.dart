import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final AuthService _auth = AuthService();
  String? _filePath = '';
  final ImagePicker _picker = ImagePicker();

  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String username = '';

  List items = [
    'Edit First Name',
    'Edit Last Name',
    'Edit Branch',
    'Edit Phone Number',
    'Sign out',
    'Delete Account',
  ];
  List<IconData> icons = [
    Icons.account_circle,
    Icons.account_circle,
    Icons.edit_attributes_outlined,
    Icons.phone_outlined,
    Icons.logout_outlined,
    Icons.delete_forever_outlined
  ];

  late final TextEditingController firstNameEditingController;
  late final TextEditingController lastNameEditingController;
  late final TextEditingController emailEditingController;
  late final TextEditingController phoneNumberEditingController;

  @override
  void initState() {
    super.initState();
    _loadVariables();
    _loadControllers();
  }

  _loadControllers() async {
    await _loadVariables();
    firstNameEditingController = TextEditingController(text: firstName);
    lastNameEditingController = TextEditingController(text: lastName);
    emailEditingController = TextEditingController(text: email);
    phoneNumberEditingController = TextEditingController(text: phoneNumber);
  }

  _loadVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _filePath = (prefs.getString('profileImage') ?? '');
      firstName = (prefs.getString('firstName') ?? '');
      lastName = (prefs.getString('lastName') ?? '');
      username = "$firstName $lastName";
      email = (prefs.getString('email') ?? '');
      phoneNumber = (prefs.getString('phoneNumber') ?? '');
    });
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    final file = File(pickedFile!.path);
    final directory = await getApplicationDocumentsDirectory();

    final File profileImage =
        await file.copy("${directory.path}/${pickedFile.name}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage', profileImage.path);
    setState(() => _filePath = prefs.getString('profileImage'));
  }

  Widget bottomSheet() {
    return Container(
        height: 150,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(children: <Widget>[
          const Text('Choose Profile Photo', style: TextStyle(fontSize: 20)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  const Text("Camera"),
                  IconButton(
                    color: Colors.black,
                    icon: const Icon(Icons.camera),
                    iconSize: 80,
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Gallery'),
                  IconButton(
                    color: Colors.black,
                    icon: const Icon(Icons.image),
                    iconSize: 80,
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
          )
        ]));
  }

  ImageProvider<Object> image() {
    final image = _filePath != ''
        ? FileImage(File(_filePath!))
        : const AssetImage(
            'assets/logo.png',
            // fit: BoxFit.contain,
          );

    return image as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Account Information'),
        backgroundColor: Colors.blue[800],
        elevation: 0.0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          SizedBox(
            height: 128,
            width: 128,
            child: Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.blue[800],
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (builder) => bottomSheet());
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.grey.shade100,
                              radius: 55.0,
                              backgroundImage: image()),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[800],
                      radius: 16,
                      child: const Icon(Icons.add_a_photo_outlined,
                          color: Colors.white),
                    ),
                    bottom: 0,
                    right: 8,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(username,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(height: 6),
          Flexible(
            child: ListView.separated(
                padding: const EdgeInsets.all(5.0),
                physics: const BouncingScrollPhysics(),
                itemCount: 6,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      if (index == 0) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Edit First Name'),
                            content: TextField(
                              controller: firstNameEditingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'CANCEL'),
                                child: const Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('firstName',
                                      firstNameEditingController.text);
                                  Navigator.pop(context);
                                },
                                child: const Text('UPDATE'),
                              ),
                            ],
                          ),
                        );
                      } else if (index == 1) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Edit Last Name'),
                            content: TextField(
                              controller: lastNameEditingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'CANCEL'),
                                child: const Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('lastName',
                                      lastNameEditingController.text);
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: const Text('UPDATE'),
                              ),
                            ],
                          ),
                        );
                      } else if (index == 2) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Edit Email'),
                            content: TextField(
                              controller: emailEditingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'CANCEL'),
                                child: const Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString(
                                      'email', emailEditingController.text);
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: const Text('UPDATE'),
                              ),
                            ],
                          ),
                        );
                      } else if (index == 3) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Edit Phone Number'),
                            content: TextField(
                              controller: phoneNumberEditingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'CANCEL'),
                                child: const Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('phoneNumber',
                                      phoneNumberEditingController.text);
                                  setState(() => const Account());
                                  Navigator.pop(context);
                                },
                                child: const Text('UPDATE'),
                              ),
                            ],
                          ),
                        );
                      } else if (index == 4) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Sign Out'),
                            content: const Text(
                                'Are you sure you want to sign out of your account?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'NO'),
                                child: const Text('NO'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await _auth.signOut();
                                },
                                child: const Text('YES'),
                              ),
                            ],
                          ),
                        );
                      } else if (index == 5) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Delete Account?',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                            content: const Text(
                              'This Action is Permanent and Cannot be Reversed!',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'NO'),
                                child: const Text('NO'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await _auth.currentUser!.delete();
                                },
                                child: const Text('YES',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    title: Text(items[index]),
                    leading: Icon(icons[index]),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
