import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/DataModels/DoctorModel.dart';
import 'package:doctor_hunt/screens/DoctorTimeSelection.dart';
import 'package:flutter/material.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({Key? key}) : super(key: key);

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {

  List<Doctor> doctorList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              doctorList = snapshot.data!.docs.map((doc) => Doctor.fromJson(doc.data() as Map<String, dynamic>)).toList();
            }
            return ListView.builder(
              itemCount: doctorList.length,
              itemBuilder: (BuildContext context, int index) {
                Doctor doctor = doctorList[index];

                return InkWell(
                  onTap: () {
                    // Navigate to the other page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  DoctorTimeSelection(doctor: doctorList[index]),
                      ),
                    );
                  },
                  child: Container(
                    height: 150.0,
                    margin: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Row(
                        children: [
                          SizedBox(
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
                          const SizedBox(height: 10,),
                           Column(
                            children: [
                              Text(
                                doctor.fullName ?? 'N/A',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(doctor.specialization ?? 'N/A'),
                              Text(doctor.hospitalName ?? 'N/A'),
                              Text(doctor.contact ?? 'N/A'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        ),
      ),
    );
  }
}
