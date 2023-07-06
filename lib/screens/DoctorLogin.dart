import 'package:doctor_hunt/screens/DoctorHomeScreen.dart';
import 'package:doctor_hunt/screens/DoctorRegister.dart';
import 'package:doctor_hunt/screens/paitent_login.dart';
import 'package:flutter/material.dart';

class DoctorLogin extends StatefulWidget {
  const DoctorLogin({Key? key}) : super(key: key);

  @override
  State<DoctorLogin> createState() => _DoctorLoginState();
}

class _DoctorLoginState extends State<DoctorLogin> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70,),
            const Center(child: Image(image: AssetImage('assets/logo.png'))),
            const SizedBox(height: 20,),
            const SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text("Welcome Doctor",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,

                        fontWeight: FontWeight.bold,
                        fontFamily: 'Rubik'
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Login as a Doctor",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Rubik'
                    ),
                  )

                ],
              ),
            ),
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    TextFormField(
                      decoration:const  InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email'
                      ),
                    ),
                    const SizedBox(height: 40,),
                    TextFormField(
                      obscureText: _obscureText,
                      decoration:  InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: IconButton(onPressed: (){
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          }, icon: const Icon(Icons.visibility))
                      ),
                    ),
                    const SizedBox(height: 40,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> const DoctorHomeScreen()));

                          }, child: const Text("Login"),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an Account?",
                  style: TextStyle(
                      fontSize: 15
                  ),),
                TextButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const DoctorRegister()));
                }, child: const Text("SIGN UP"))
              ],
            ),
            const SizedBox(height: 60,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Login as a Paitent",
                  style: TextStyle(
                      fontSize: 20
                  ),),
                TextButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const PaitentLogin()));
                }, child: const Text("CLICK HERE",
                style: TextStyle(
                  fontSize: 18
                ),))
              ],
            )
          ],
        ),
      )),

    );
  }
}
