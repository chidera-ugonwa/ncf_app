import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

class CopyCode extends StatefulWidget {
  final dynamic meetingCode;
  const CopyCode({Key? key, this.meetingCode}) : super(key: key);

  @override
  State<CopyCode> createState() => _CopyCodeState();
}

class _CopyCodeState extends State<CopyCode> {
  final serverText = TextEditingController();
  final subjectText = TextEditingController(text: 'NCF Meeting');
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Copy Meeting Code"),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),
              const Text(
                "Please copy your meeting code below",
              ),
              const SizedBox(height: 16.0),
              Container(
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF1565C0), width: 2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.meetingCode),
                      IconButton(
                          icon: isPressed == true
                              ? const Icon(
                                  Icons.check_rounded,
                                )
                              : const Icon(Icons.content_copy_outlined),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: widget.meetingCode));
                            setState(() => isPressed = true);
                          },
                          color: Colors.blue)
                    ],
                  )),
              const SizedBox(height: 16.0),
              const Text(
                  "Use this code to invite other participants to join your meeting"),
              const Divider(height: 48.0, thickness: 2.0),
              SizedBox(
                height: 64.0,
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    _joinMeeting();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Start Meeting",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _joinMeeting() async {
    String? serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;

    Map<FeatureFlag, Object> featureFlags = {
      FeatureFlag.isAddPeopleEnabled: false,
      FeatureFlag.isInviteEnabled: false,
    };

    // Define meetings options here
    var options = JitsiMeetingOptions(
        roomNameOrUrl: widget.meetingCode,
        serverUrl: serverUrl,
        subject: subjectText.text,
        featureFlags: featureFlags);

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
        onOpened: () => debugPrint("onOpened"),
        onConferenceWillJoin: (url) {
          debugPrint("onConferenceWillJoin: url: $url");
        },
        onConferenceJoined: (url) {
          debugPrint("onConferenceJoined: url: $url");
        },
        onConferenceTerminated: (url, error) {
          debugPrint("onConferenceTerminated: url: $url, error: $error");
        },
        onAudioMutedChanged: (isMuted) {
          debugPrint("onAudioMutedChanged: isMuted: $isMuted");
        },
        onVideoMutedChanged: (isMuted) {
          debugPrint("onVideoMutedChanged: isMuted: $isMuted");
        },
        onScreenShareToggled: (participantId, isSharing) {
          debugPrint(
            "onScreenShareToggled: participantId: $participantId, "
            "isSharing: $isSharing",
          );
        },
        onParticipantJoined: (email, name, role, participantId) {
          debugPrint(
            "onParticipantJoined: email: $email, name: $name, role: $role, "
            "participantId: $participantId",
          );
        },
        onParticipantLeft: (participantId) {
          debugPrint("onParticipantLeft: participantId: $participantId");
        },
        onParticipantsInfoRetrieved: (participantsInfo, requestId) {
          debugPrint(
            "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
            "requestId: $requestId",
          );
        },
        onChatMessageReceived: (senderId, message, isPrivate) {
          debugPrint(
            "onChatMessageReceived: senderId: $senderId, message: $message, "
            "isPrivate: $isPrivate",
          );
        },
        onChatToggled: (isOpen) => debugPrint("onChatToggled: isOpen: $isOpen"),
        onClosed: () => debugPrint("onClosed"),
      ),
    );
  }
}
