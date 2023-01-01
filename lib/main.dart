import 'package:flutter/material.dart';
import 'package:myapp/screens/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAdy4Bf1OhH-WhmjBOtapu-diTkp63YWCc",
      appId: "1:458828247862:android:798615ce9cef025a28b997",
      messagingSenderId:
          "458828247862-sugtje4dtt7kbeml24vdamp08lcptr4j.apps.googleusercontent.com",
      projectId: "ncf-app-6bf1b",
    ),
  );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'NCF',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: FirebaseAuth.instance.authStateChanges(),
      initialData: null,
      child: MaterialApp(
        title: 'NCF App',
        theme: ThemeData(
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blueAccent),
                    foregroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white)))),
        home: EasySplashScreen(
          logo: Image.asset('assets/dclogo.png'),
          title: const Text(
            "New Covenant Family",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.indigo.shade900,
          showLoader: false,
          navigator: const Wrapper(),
          durationInSeconds: 5,
          loaderColor: Colors.white,
          logoWidth: 80.0,
        ),
      ),
    );
  }
}
