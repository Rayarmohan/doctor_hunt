import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/DataModels/PaitentModel.dart';
import 'package:doctor_hunt/screens/DoctorList.dart';
import 'package:doctor_hunt/screens/DoctorSpecialScreen.dart';
import 'package:doctor_hunt/screens/widgets/PaitentDoctorList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaitentHome extends StatefulWidget {
  const PaitentHome({Key? key}) : super(key: key);

  @override
  State<PaitentHome> createState() => _PaitentHomeState();
}

class _PaitentHomeState extends State<PaitentHome> {
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

  List<IconData> doctorSpecializations = [
    Icons.medical_services_rounded,
    Icons.favorite_border,
    Icons.monitor_heart,
    Icons.hearing,
    Icons.person,
    Icons.healing,
    Icons.psychology,
  ];

  List<Color> doctorSpecializationColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.teal,
  ];

  final List<String> specialization = [
    'Pediatrician',
    'Cardiology',
    'Dental',
    'ENT',
    'Neurologist',
    'Anesthesiology',
    'Orthopedics',
    'Psychiatrist'
  ];

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    ) : Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 4,
          decoration: const BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _patient != null ? 'Hi, ${_patient!.fullName}' : 'Hi, Patient Name',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _patient != null ? NetworkImage(_patient!.imagePath!) : null,
                    child: _patient == null ? const Icon(Icons.person) : null,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "  Find Your Doctor",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 60,
        ),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: doctorSpecializations.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 20 : 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder:
                        (ctx)=>DoctorSpecialScreen(specialization: specialization[index])));
                  },
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: doctorSpecializationColors[index],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(doctorSpecializations[index], color: Colors.white),
                        const SizedBox(height: 5),
                        Text(
                          specialization[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
          ,
        ),
        const SizedBox(
          height: 80,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "  Popular Doctors",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const DoctorList()));
              },
              child: const Text("See all"),
            ),
          ],
        ),
        const SizedBox(
          height: 280,
          child: PaitentDoctorList(),
        ),
      ],
    );
  }
}
