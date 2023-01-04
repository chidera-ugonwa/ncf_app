import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
//import 'package:flutterwave_standard/models/subaccount.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _email = '';
String _phoneNumber = '';
String _firstName = '';
String _lastName = '';

class Pay extends StatefulWidget {
  final String publicKey;
  const Pay({Key? key, required this.publicKey}) : super(key: key);

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

  String selectedCurrency = "NGN";

  bool isTestMode = true;
  //final pbk = "FLWPUBK_TEST";

  @override
  void initState() {
    super.initState();
    _loadVariables();
  }

  _loadVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = (prefs.getString('email') ?? '');
      _firstName = (prefs.getString('firstName') ?? '');
      _lastName = (prefs.getString('lastName') ?? '');
      _phoneNumber = (prefs.getString('phoneNumber') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    //currencyController.text = selectedCurrency;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Give"),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 20),
              _buildTextField(
                  labelText: "Enter Amount", controller: amountController),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Use Debug"),
                    Switch(
                      onChanged: (value) => {
                        setState(() {
                          isTestMode = value;
                        })
                      },
                      value: isTestMode,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: ElevatedButton(
                  onPressed: _onPressed,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[800])),
                  child: const Text(
                    "Make Payment",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onPressed() {
    if (formKey.currentState!.validate()) {
      _handlePaymentInitialization();
    }
  }

  _handlePaymentInitialization() async {
    final Customer customer = Customer(
        name: "$_firstName $_lastName",
        phoneNumber: _phoneNumber,
        email: _email);

    //final subAccounts = [
    //SubAccount(id: "RS_1A3278129B808CB588B53A14608169AD", transactionChargeType: "flat", transactionPercentage: 25),
    //SubAccount(id: "RS_C7C265B8E4B16C2D472475D7F9F4426A", transactionChargeType: "flat", transactionPercentage: 50)
    //];

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey: getPublicKey(),
        currency: selectedCurrency,
        redirectUrl: "https://google.com",
        txRef: const Uuid().v1(),
        amount: amountController.text.toString().trim(),
        customer: customer,
        //subAccounts: subAccounts,
        paymentOptions: "card",
        customization: Customization(title: "Test Payment"),
        isTestMode: isTestMode);
    final ChargeResponse response = await flutterwave.charge();
    // ignore: unnecessary_null_comparison
    if (response != null) {
      showLoading(response.status.toString());
      debugPrint("${response.toJson()}");
    } else {
      showLoading("No Response!");
    }
  }

  String getPublicKey() {
    return widget.publicKey;
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: "Enter Amount"),
      validator: (value) => value!.isNotEmpty ? null : "Amount is required",
    );
  }
}
