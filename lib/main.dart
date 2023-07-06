import 'package:doctor_hunt/screens/splash_screen.dart';
import 'package:doctor_hunt/screens/start_screen1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor Hunt',
      theme: ThemeData(
        primaryColor: Colors.greenAccent,
        primarySwatch: Colors.teal,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.greenAccent
        ),

      ),
      home: const SplashScreen(),
    );
  }
}



