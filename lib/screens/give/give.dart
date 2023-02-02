import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/screens/give/pay.dart';

class Give extends StatefulWidget {
  const Give({Key? key}) : super(key: key);

  @override
  State<Give> createState() => _GiveState();
}

class _GiveState extends State<Give> {
  String branch = '';
  Map detailsMap = {};

  @override
  void initState() {
    super.initState();
    _getBranchFields();
  }

  _getBranch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branch = (prefs.getString('branch') ?? '');
  }

  Future<dynamic> _getBranchFields() async {
    await _getBranch();
    final branchFields =
        FirebaseFirestore.instance.collection("ChurchData").doc(branch);
    branchFields.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() => detailsMap = data);
      },
      onError: (e) => debugPrint("Error getting document: $e"),
    );

    return branchFields;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Give'),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                const Text('Give an Offering', style: TextStyle(fontSize: 20)),
                Card(
                  elevation: 10.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      ListTile(
                        title: Text(detailsMap['OfferingAccountNumber'] ?? ''),
                        leading: Text(detailsMap['OfferingBankName'] ?? ''),
                        subtitle: Text(detailsMap['OfferingAccountName'] ?? ''),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Pay(
                                publicKey: detailsMap['Public Key'],
                              );
                            }));
                          },
                          child: const Text(
                            'Pay with Card',
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Pay your Tithe', style: TextStyle(fontSize: 20)),
                Card(
                  elevation: 10.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      ListTile(
                        title: Text(detailsMap['TitheAccountNumber'] ?? ''),
                        leading: Text(detailsMap['TitheBankName'] ?? ''),
                        subtitle: Text(detailsMap['TitheAccountName'] ?? ''),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Pay(
                                publicKey: detailsMap['Public Key'],
                              );
                            }));
                          },
                          child: const Text(
                            'Pay with Card',
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Donate to the Church',
                    style: TextStyle(fontSize: 20)),
                Card(
                  elevation: 10.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      ListTile(
                        title: Text(detailsMap['DonationsAccountNumber'] ?? ''),
                        leading: Text(detailsMap['DonationsBankName'] ?? ''),
                        subtitle:
                            Text(detailsMap['DonationsAccountName'] ?? ''),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Pay(
                                publicKey: detailsMap['Public Key'],
                              );
                            }));
                          },
                          child: const Text(
                            'Pay with Card',
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
