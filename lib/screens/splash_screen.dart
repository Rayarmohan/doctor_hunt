import 'package:doctor_hunt/screens/start_screen1.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/logo.png')),
              SizedBox(height: 10,),
              Text("Doctor Hunt",
              style: TextStyle(fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    gotoStart();
    super.initState();
  }

  Future<void> gotoStart() async{
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>const StartScreen1()));
  }
}
