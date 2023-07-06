import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/DataModels/DoctorModel.dart';
import 'package:flutter/material.dart';

class DoctorSpecialScreen extends StatefulWidget {
  final String specialization;
  const DoctorSpecialScreen({Key? key, required this.specialization}) : super(key: key);

  @override
  State<DoctorSpecialScreen> createState() => _DoctorSpecialScreenState();
}

class _DoctorSpecialScreenState extends State<DoctorSpecialScreen> {
  List<Doctor> doctorList = [];

  @override
  void initState() {
    super.initState();
    // Call the method to fetch doctors with the selected specialization
    fetchDoctorsBySpecialization();
  }

  Future<void> fetchDoctorsBySpecialization() async {
    try {
      // Replace this code with your actual method to fetch doctors from Firebase
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('specialization', isEqualTo: widget.specialization)
          .get();

      setState(() {
        // Convert the query snapshot into a list of doctors
        doctorList = querySnapshot.docs
            .map((doc) => Doctor.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch doctors'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.specialization),
      ),
      body: ListView.builder(
        itemCount: doctorList.length,
        itemBuilder: (ctx, index) {
          final Doctor doctor = doctorList[index];
          return Container(
            height: 150.0,
            margin: const EdgeInsets.all(8.0),
            child: Card(
              child: Row(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SizedBox(
                      height: 150.0,
                      child: Container(
                        width: 150.0,
                        decoration:  BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(3),
                            bottomRight: Radius.circular(5),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(doctor.imagePath ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "      ${doctor.fullName}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("          ${doctor.specialization}"),
                      Text("          ${doctor.hospitalName}"),
                      Text("          ${doctor.contact}"),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
