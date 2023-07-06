import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/DataModels/AppointmentModel.dart';
import 'package:doctor_hunt/DataModels/DoctorModel.dart';
import 'package:doctor_hunt/DataModels/PaitentModel.dart';
import 'package:doctor_hunt/screens/PaitentHomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorTimeSelection extends StatefulWidget {
  final Doctor doctor;

  const DoctorTimeSelection({Key? key, required this.doctor}) : super(key: key);

  @override
  State<DoctorTimeSelection> createState() => _DoctorTimeSelectionState();
}

class _DoctorTimeSelectionState extends State<DoctorTimeSelection> {
  DateTime? _selectedDate;
  List<String> timeSlots = ['9am', '11am', '2pm', '4pm', '6pm', '8pm'];
  String? selectedTimeSlot;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2024),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _showAppointmentDialog() async {
    final selectedDate = _selectedDate;
    final selectedSlot = selectedTimeSlot;

    if (selectedDate != null && selectedSlot != null) {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final formattedDate = dateFormat.format(selectedDate);

      final message = 'Your appointment is booked on $formattedDate at $selectedSlot';

      // Get the currently logged-in user
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Retrieve the details of the logged-in patient from Firebase
        final DocumentSnapshot patientSnapshot =
        await FirebaseFirestore.instance.collection('patients').doc(currentUser.uid).get();

        if (patientSnapshot.exists) {
          final patientData = patientSnapshot.data() as Map<String, dynamic>;

          // Create an Appointment object with the selected details and logged-in patient's information
          final appointment = Appointment(
            doctor: widget.doctor,
            patient: Patient.fromJson(patientData),
            appointmentDateTime: DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              int.parse(selectedSlot.replaceAll(RegExp('[^0-9]'), '')),
            ),
          );

          try {
            // Store the appointment details in Firebase
            await FirebaseFirestore.instance.collection('appointments').add(appointment.toJson());

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Appointment Booked'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(message),
                      const SizedBox(height: 10),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>PaitentHomeScreen()));
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to book appointment'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to retrieve patient information'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not logged in'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentTime = DateTime.now();
    DateTime selectedDateTime = _selectedDate ?? currentTime;

    List<String> availableTimeSlots = timeSlots.where((timeSlot) {
      String hourString = timeSlot.replaceAll(RegExp('[^0-9]'), '');
      int hour = int.parse(hourString);
      DateTime time = DateTime(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
        hour,
      );
      return time.isAfter(currentTime);
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
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
                            image: NetworkImage(widget.doctor.imagePath ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                     Column(
                      children: [
                        Text(
                          widget.doctor.fullName ?? 'N/A',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(widget.doctor.specialization ?? 'N/A'),
                        Text(widget.doctor.hospitalName ?? 'N/A'),
                        Text(widget.doctor.contact ?? 'N/A'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Appointment Date",
                      suffixIcon: Icon(Icons.calendar_month_rounded),
                    ),
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                          : '',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Select Appointment Date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Available Time Slots:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: availableTimeSlots.length,
                itemBuilder: (BuildContext context, int index) {
                  final timeSlot = availableTimeSlots[index];
                  final isSelected = timeSlot == selectedTimeSlot;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTimeSlot = isSelected ? null : timeSlot;
                      });
                    },
                    child: ListTile(
                      title: Text(
                        timeSlot,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.blue : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _showAppointmentDialog();
                    },
                    child: const Text('Book Appointment'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
