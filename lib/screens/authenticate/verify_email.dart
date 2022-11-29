import 'package:flutter/material.dart';
import 'package:myapp/screens/home/home.dart';
import 'package:myapp/services/auth.dart';
//import 'package:myapp/screens/authenticate/sign_in.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
  final bool isEmailVerified = false;
}

class _VerifyEmailState extends State<VerifyEmail> {
  final AuthService _auth = AuthService();

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Verify Email'),
          backgroundColor: Colors.blue[900],
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('A Verification Link has been sent to your email',
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
                const Text("Did'nt get an email?"),
                const SizedBox(height: 16),
                const Text("1. Check that the email you entered is correct",
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
                const Text("2. Check the spam folder in your mail",
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
                const Text("3. Check your network connection",
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
                const Text(
                    "PS: After you verify your mail, click the 'I've Verified' button below",
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue[900],
                  child: MaterialButton(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () async {
                      await _auth.reload();
                      if (_auth.currentUser != null) {
                        if (!_auth.currentUser!.emailVerified) {
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()),
                          );
                        }
                      }
                    },
                    child: Text("I've verified",
                        style:
                            TextStyle(color: Colors.blue[900], fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
