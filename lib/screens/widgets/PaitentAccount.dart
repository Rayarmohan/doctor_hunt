import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/DataModels/PaitentModel.dart';
import 'package:doctor_hunt/screens/AboutPage.dart';
import 'package:doctor_hunt/screens/PaitentUpdate.dart';
import 'package:doctor_hunt/screens/paitent_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaitentAccount extends StatefulWidget {
  const PaitentAccount({Key? key}) : super(key: key);

  @override
  State<PaitentAccount> createState() => _PaitentAccountState();
}

class _PaitentAccountState extends State<PaitentAccount> {
  Patient? _patient;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails(); // Fetch patient details when the screen loads
  }

  Future<void> _fetchPatientDetails() async {
    try {
      setState(() {
        _isLoading = true; // Set loading state to true
      });

      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot patientSnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .get();

      if (patientSnapshot.exists) {
        setState(() {
          _patient = Patient.fromJson(patientSnapshot.data() as Map<String, dynamic>);
        });
      }
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Details Fecting Failed'),
        ),
      );
    } finally
    {
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Account'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Doctor hunt',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('About us'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const AboutPage()));
                // Handle Item 1 tap
              },
            ),
            ListTile(
              title: const Text('Help'),
              onTap: () {
                // Handle Item 2 tap
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async{
                // Handle Item 3 tap
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx)=>PaitentLogin()), (route) => false);
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      ) :SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              CircleAvatar(
                radius: 80,
                backgroundImage: _patient != null ? NetworkImage(_patient!.imagePath!) : null,
                child: _patient == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>PaitentUpdate()));
                },
                child: const Text("EDIT PROFILE"),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      IconData icon;
                      String text;
                      if (index == 0) {
                        icon = Icons.person;
                        text = _patient != null ? ' ${_patient!.fullName}' : 'Patient Name';
                      } else if (index == 1) {
                        icon = Icons.info;
                        text = _patient != null ? ' ${_patient!.address}' : 'Address';
                      } else {
                        icon = Icons.phone;
                        text = _patient != null ? ' ${_patient!.contact}' : 'Contact';
                      }
                      return ListTile(
                        leading: Icon(icon),
                        title: Text(text),
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return const Divider(
                        thickness: 1.0,
                        color: Colors.grey,
                      );
                    },
                    itemCount: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
