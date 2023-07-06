import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/DataModels/PaitentModel.dart';
import 'package:doctor_hunt/screens/DoctorLogin.dart';
import 'package:doctor_hunt/screens/ForgotPassword.dart';
import 'package:doctor_hunt/screens/PaitentHomeScreen.dart';
import 'package:doctor_hunt/screens/PaitentRegister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaitentLogin extends StatefulWidget {
   const PaitentLogin({Key? key}) : super(key: key);

  @override
  State<PaitentLogin> createState() => _PaitentLoginState();
}

class _PaitentLoginState extends State<PaitentLogin> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _Patientlogin() async{
    if (_formKey.currentState!.validate())
      {
        try {
          setState(() {
            _isLoading = true; // Set loading state to true
          });
          // ...
          // Step 3: Sign in the user
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful'),
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx)=>PaitentHomeScreen()), (route) => false);

          // ...
        } catch (e) {
          // Handle login failure
          // ...
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(' Failed'),
            ),
          );
        }
        finally
        {
          setState(() {
            _isLoading = false; // Set loading state to false
          });
        }
      }
    // Inside the `_Patientlogin` function


  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      ) :SafeArea(child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 70,),
              const Center(child: Image(image: AssetImage('assets/logo.png'))),
              const SizedBox(height: 20,),
              const SizedBox(

                width: double.infinity,
                child:  Column(
                  children: [
                    Text("Welcome to Doctor Hunt",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,

                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rubik'
                    ),
                    ),
                    SizedBox(height: 20,),
                    Text("Login as a Paitent",
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
                        controller: _emailController,
                        decoration:const  InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email'
                        ),
                        validator: (value){
                          if(value!.isEmpty)
                          {
                            return 'Please Enter Email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40,),
                      TextFormField(
                        controller: _passwordController,
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
                        validator: (value){
                          if(value!.isEmpty)
                          {
                            return 'Please Password';
                          }
                          return null;
                        },
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
                              _Patientlogin();

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
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const PaitentRegister()));
                  }, child: const Text("SIGN UP"))
                ],
              ),
              const SizedBox(height: 60,),
              TextButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ForgotPasword()));
              }, child: const Text("Forgot Password",
                style: TextStyle(
                    fontSize: 18
                ),)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login as a Doctor",
                    style: TextStyle(
                        fontSize: 20
                    ),),
                  TextButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const DoctorLogin()));
                  }, child: const Text("CLICK HERE",
                  style: TextStyle(
                    fontSize: 18
                  ),))
                ],
              )
            ],
          ),
        ),
      )),

    );
  }
}
