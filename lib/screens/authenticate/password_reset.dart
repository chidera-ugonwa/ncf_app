import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key? key}) : super(key: key);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
// form key
  final _formKey = GlobalKey<FormState>();

// define error
  String error = 'null';

//showAlert widget defined
  Widget showAlert() {
    if (error != 'null') {
      if (error == 'Password Reset Email Sent') {
        return Container(
          color: Colors.blue.shade900,
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.notifications, color: Colors.white),
            ),
            const Expanded(
                child: Text(
                    'Password Reset Email Sent, Click the back arrow above to sign in',
                    style: TextStyle(
                      color: Colors.white,
                    ))),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() => error = '');
              },
              color: Colors.white,
            ),
          ]),
        );
      }
      return Container(
        color: Colors.redAccent,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.error_outline, color: Colors.white),
          ),
          Expanded(
              child: Text(error,
                  style: const TextStyle(
                    color: Colors.white,
                  ))),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() => error = 'null');
            },
            color: Colors.white,
          ),
        ]),
      );
    }
    return const SizedBox(
      height: 0,
    );
  }

// isLoading is initially false
  bool isLoading = false;

//editing controller
  final TextEditingController emailController = TextEditingController();

  dynamic check;

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      setState(() => check = "Password Reset Email Sent");
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        prefixIconColor: Colors.blue,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //Reset Password Button
    final resetPasswordButton = isLoading
        ? const CircularProgressIndicator(
            backgroundColor: Colors.grey,
            color: Colors.blue,
            strokeWidth: 5,
          )
        : Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            color: Colors.blue[900],
            child: MaterialButton(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  resetPassword();
                  setState(() {
                    isLoading = false;
                  });
                  String test = check.toString();
                  setState(() => error = test);
                }
              },
              child: const Text(
                'Reset Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  showAlert(),
                  const SizedBox(height: 45),
                  Text(
                    'Enter your Email to Reset your Password',
                    style: TextStyle(
                      color: Colors.indigo.shade900,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 45),
                  emailField,
                  const SizedBox(height: 25),
                  resetPasswordButton,
                  const SizedBox(height: 05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
