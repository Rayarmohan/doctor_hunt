import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/DataModels/DoctorModel.dart';
import 'package:doctor_hunt/screens/DoctorTimeSelection.dart';
import 'package:flutter/material.dart';

class PaitentDoctorList extends StatefulWidget {
  const PaitentDoctorList({Key? key}) : super(key: key);

  @override
  State<PaitentDoctorList> createState() => _PaitentDoctorListState();
}

class _PaitentDoctorListState extends State<PaitentDoctorList> {

  List<Doctor> doctorList = [];

  List<bool> isFavoriteList = List.generate(10, (index) => false);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:  FirebaseFirestore.instance.collection('doctors').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          doctorList = snapshot.data!.docs.map((doc) => Doctor.fromJson(doc.data() as Map<String, dynamic>)).toList();
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: doctorList.length, // Use the length of the doctor list
          itemBuilder: (BuildContext context, int index) {
            Doctor doctor = doctorList[index]; // Get the doctor at the current index

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  DoctorTimeSelection(doctor: doctorList[index]),
                  ),
                );
              },
              child: Container(
                width: 160.0,
                height: 200.0,
                margin: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100.0,
                        child: Container(
                          width: 160.0,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(doctor.imagePath ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: isFavoriteList[index] ? Colors.red : Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isFavoriteList[index] = !isFavoriteList[index];
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),
                      Text(
                        doctor.fullName ?? 'N/A',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(doctor.specialization ?? 'N/A'),
                      Text(doctor.hospitalName ?? 'N/A'),
                      Text(doctor.contact ?? 'N/A'),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    );

  }
}
