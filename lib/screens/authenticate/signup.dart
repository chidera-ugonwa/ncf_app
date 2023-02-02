import 'package:flutter/material.dart';
import 'package:myapp/services/auth.dart';
//import 'package:myapp/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  // ignore: use_key_in_widget_constructors
  const SignUp({required this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _email = '';
  String _firstName = '';
  String _phoneNumber = '';
  String _lastName = '';
  List branches = [];

  final AuthService _auth = AuthService();

// Initially password is obscure
  bool _obscureText = true;

//_obscureText2 for confirm password
  bool _obscureText2 = true;

//initially isLoading is false
  bool isLoading = false;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // _toggle2 for confirm password
  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  // form key
  final _formKey = GlobalKey<FormState>();

  //error defined
  dynamic error = '';

  //showAlert widget defined
  Widget showAlert() {
    if (error != '') {
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
              setState(() => error = '');
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

  Future<List> _getDocumentsList() async {
    await FirebaseFirestore.instance.collection('ChurchData').get().then(
      (res) {
        //print("Successfully completed");
        for (var doc in res.docs) {
          //print(doc.id);
          branches.add(doc.id);
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );

    return branches;
  }

  // editing controller
  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final phoneNumberEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getDocumentsList();
  }

  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (val) => val!.isEmpty ? 'Fill out this field' : null,
      onChanged: (val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() => _firstName = val.toString());
        prefs.setString('firstName', _firstName);
      },
      onSaved: (value) async {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        prefixIconColor: Colors.blue,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'First Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // last name field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      keyboardType: TextInputType.name,
      validator: (val) => val!.isEmpty ? 'Fill out this field' : null,
      onChanged: (val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() => _lastName = val.toString());
        prefs.setString('lastName', _lastName);
      },
      onSaved: (value) async {
        lastNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        prefixIconColor: Colors.blue,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Last Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (val) => val!.isEmpty ? 'Fill out this field' : null,
      onChanged: (val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() => _email = val.toString());
        prefs.setString('email', _email);
      },
      onSaved: (value) async {
        emailEditingController.text = value!;
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

    //phoneNumber field
    final phoneNumberField = TextFormField(
      autofocus: false,
      controller: phoneNumberEditingController,
      keyboardType: TextInputType.number,
      validator: (val) => val!.isEmpty ? 'Fill out this field' : null,
      onChanged: (val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() => _phoneNumber = val.toString());
        prefs.setString('phoneNumber', _phoneNumber);
      },
      onSaved: (value) async {
        phoneNumberEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone),
        prefixIconColor: Colors.blue,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Phone Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    String _dropdownValue = 'Branch Name';

    //choose branch field
    Widget chooseBranch = DropdownButtonFormField(
        value: _dropdownValue,
        validator: (val) => val == 'Branch Name' ? 'Fill out this field' : null,
        items: branches.map((result) {
          return DropdownMenuItem(child: Text(result), value: result);
        }).toList(),
        onChanged: (value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          setState(() => _dropdownValue = value.toString());
          prefs.setString("branch", _dropdownValue);
        });

    // password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: _obscureText,
      validator: (val) => val!.length < 6
          ? 'Password must contain at least 6 characters'
          : null,
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        prefixIconColor: Colors.blue,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffix: InkWell(
          onTap: _toggle,
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
      ),
    );

    // confirm password field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: _obscureText2,
      validator: (val) => val != passwordEditingController.text
          ? 'Not the same with password'
          : null,
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        prefixIconColor: Colors.blue,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Confirm Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffix: InkWell(
          onTap: _toggle2,
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
        ),
      ),
    );

    // set email password and error variables
    dynamic email = emailField.controller!.text;
    dynamic password = passwordField.controller!.text;

    //Sign up
    final signUpButton = isLoading
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
                  dynamic result =
                      await _auth.registerWithEmailAndPassword(email, password);
                  if (result != "Instance of 'UserId'") {
                    setState(() => error = result);
                    //print(result);
                  }
                }
              },
              child: const Text(
                'Sign Up',
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
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    showAlert(),
                    SizedBox(
                      height: 120,
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 25),
                    firstNameField,
                    const SizedBox(height: 15),
                    lastNameField,
                    const SizedBox(height: 15),
                    emailField,
                    const SizedBox(height: 15),
                    phoneNumberField,
                    const SizedBox(height: 15),
                    chooseBranch,
                    const SizedBox(height: 15),
                    passwordField,
                    const SizedBox(height: 15),
                    confirmPasswordField,
                    const SizedBox(height: 15),
                    signUpButton,
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account?"),
                        GestureDetector(
                            onTap: () {
                              widget.toggleView();
                            },
                            child: Text(
                              '  Sign In',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[900],
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
