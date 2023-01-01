import 'package:flutter/material.dart';
import 'package:myapp/screens/meet/meet_screen.dart';
import 'package:myapp/screens/meet/copy_code.dart';
import 'package:random_password_generator/random_password_generator.dart';

class Meet extends StatefulWidget {
  const Meet({Key? key}) : super(key: key);

  @override
  State<Meet> createState() => _MeetState();
}

class _MeetState extends State<Meet> with AutomaticKeepAliveClientMixin {
  final serverText = TextEditingController();
  final subjectText = TextEditingController(text: 'NCF Meeting');
  final generate = RandomPasswordGenerator();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text('Meet'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () async {
                  String meetingCode = generate.randomPassword(
                      letters: true,
                      numbers: true,
                      passwordLength: 9,
                      specialChar: false,
                      uppercase: true);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CopyCode(
                      meetingCode: meetingCode,
                    );
                  }));
                },
                child: const Text('New meeting'),
              ),
              OutlinedButton(
                  style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                      side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.blue)),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                      foregroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue)),
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const Meeting();
                    }));
                  },
                  child: const Text('Join with a code'))
            ],
          )
        ],
      ),
    );
  }
}
