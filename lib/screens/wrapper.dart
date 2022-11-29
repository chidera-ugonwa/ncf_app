import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/authenticate/authenticate.dart';
import 'package:myapp/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:myapp/screens/authenticate/verify_email.dart';

//import 'package:myapp/models/user.dart';
class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user != null) {
      if (!user.emailVerified) {
        return const VerifyEmail();
      }
      return const Home();
    } else {
      return const Authenticate();
    }
  }
}
