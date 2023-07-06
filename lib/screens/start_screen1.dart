import 'package:doctor_hunt/screens/paitent_login.dart';
import 'package:doctor_hunt/screens/start_screen2.dart';
import 'package:flutter/material.dart';

class StartScreen1 extends StatelessWidget {
  const StartScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              const Image(
                image: AssetImage('assets/start1.png'),
                height: 300,
                width: 300,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Doctors X Paitents",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: 'Rubik',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "One solution for Doctors and paitents, Connect Doctors and Paitents accross the world, Make Doctor Appointments Easy",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 50, // Adjust the height as needed
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => const StartScreen2()),
                        );
                      },
                      child: const Text("Next"),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const PaitentLogin()),
                  );
                },
                child: const Text("Skip"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
