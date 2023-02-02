import 'package:flutter/material.dart';
import 'package:myapp/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'NCF',
    options: const FirebaseOptions(
      apiKey: "AIzaSyAdy4Bf1OhH-WhmjBOtapu-diTkp63YWCc",
      appId: "1:458828247862:android:798615ce9cef025a28b997",
      messagingSenderId:
          "458828247862-sugtje4dtt7kbeml24vdamp08lcptr4j.apps.googleusercontent.com",
      projectId: "ncf-app-6bf1b",
      storageBucket: 'ncf-app-6bf1b.appspot.com',
    ),
  );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'NCF',
    androidNotificationOngoing: true,
  );

    runApp(MaterialApp(
     debugShowCheckedModeBanner: false,
      title: 'NCF',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.blue.shade800),
                  foregroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.white)))),
      home: StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
          child: const Wrapper())));  
}
