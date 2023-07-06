import 'package:doctor_hunt/screens/paitent_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasword extends StatefulWidget {
  ForgotPasword ({Key? key}) : super(key: key);

  @override
  State<ForgotPasword> createState() => _ForgotPaswordState();
}

class _ForgotPaswordState extends State<ForgotPasword> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

 TextEditingController _emailController = TextEditingController();

  void _sendPasswordResetEmail(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();

      try {
        setState(() {
          _isLoading = true; // Set loading state to true
        });
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent')),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>PaitentLogin()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send password reset email')),
        );
      }
      finally
      {
        setState(() {
          _isLoading = false; // Set loading state to false
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
    body: _isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) :
    SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
          children: [
  const SizedBox(height: 70,),
  const Center(child: Image(image: AssetImage('assets/logo.png'))),
  const SizedBox(height: 20,),
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
            ElevatedButton(onPressed: (){
              _sendPasswordResetEmail(context);

            }, child: const Text("SEND MAIL FOR RESET"),
            ),

          ],
          ),
        ),
      ),
    ),
    );
  }
}
