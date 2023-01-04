import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';

class Account extends StatelessWidget {
  final AuthService _auth = AuthService();

  Account({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton.icon(
            icon: const Icon(Icons.person_remove),
            onPressed: () async {
              await _auth.currentUser!.delete();
            },
            label: const Text('Delete'),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Account Information'),
        backgroundColor: Colors.blue[800],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            onPressed: () async {
              await _auth.reload();
              await _auth.signOut();
            },
            label: const Text('Sign Out'),
            style: TextButton.styleFrom(
              disabledForegroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
