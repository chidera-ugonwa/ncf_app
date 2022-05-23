import 'package:flutter/material.dart';
import 'package:myapp/screens/home/home.dart';
import 'package:myapp/services/auth.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
  final bool isEmailVerified = false;
}

class _VerifyEmailState extends State<VerifyEmail> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    //print('Email Verification:');
    //print(_auth.currentUser?.emailVerified);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Account Information'),
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.person),
              onPressed: () async {
                await _auth.signOut();
              },
              label: const Text('Sign Out'),
              style: TextButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const Text('A Verification Link has been sent to your email'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                await _auth.reload();
                if (_auth.currentUser != null) {
                  if (!_auth.currentUser!.emailVerified) {
                    //print('verify');
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  }
                }
              },
              child: const Text("I've verified"),
            )
          ],
        ));
  }
}
