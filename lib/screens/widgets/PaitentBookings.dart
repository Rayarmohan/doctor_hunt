import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/DataModels/DoctorModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaitentBookings extends StatelessWidget {
  const PaitentBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs: Upcoming Bookings and History
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Your Appointments"),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming Bookings'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              UpcomingBookingsTab(),
              HistoryTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class UpcomingBookingsTab extends StatefulWidget {
  const UpcomingBookingsTab({Key? key}) : super(key: key);

  @override
  State<UpcomingBookingsTab> createState() => _UpcomingBookingsTabState();
}

class _UpcomingBookingsTabState extends State<UpcomingBookingsTab> {
  @override
  Widget build(BuildContext context) {
    // Get the currently logged-in user
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text('User not logged in'),
      );
    }

    // Query the appointments collection for the logged-in patient's appointments
    final CollectionReference appointmentsCollection =
    FirebaseFirestore.instance.collection('appointments');

    return StreamBuilder<QuerySnapshot>(
      stream: appointmentsCollection
          .where('patient.id', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching appointments'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<DocumentSnapshot> appointments = snapshot.data!.docs;

        if (appointments.isEmpty) {
          return const Center(
            child: Text('No upcoming appointments'),
          );
        }

        final List<DocumentSnapshot> upcomingAppointments = [];
        final List<DocumentSnapshot> pastAppointments = [];

        // Separate appointments based on the appointment date
        final currentDate = DateTime.now();
        for (final appointment in appointments) {
          final appointmentDateTime = appointment['appointmentDateTime'] as String;
          final parsedDateTime = DateTime.parse(appointmentDateTime);
          if (parsedDateTime.isAfter(currentDate)) {
            upcomingAppointments.add(appointment);
          } else {
            pastAppointments.add(appointment);
          }
        }

        return ListView.builder(
          itemCount: upcomingAppointments.length,
          itemBuilder: (ctx, index) {
            final appointment = upcomingAppointments[index].data() as Map<String, dynamic>;
            final doctorData = appointment['doctor'] as Map<String, dynamic>;
            final doctor = Doctor.fromJson(doctorData);

            final appointmentDateTime = appointment['appointmentDateTime'] as String;
            final formattedDateTime = DateFormat('yyyy-MM-dd ' 'hh:mm').format(DateTime.parse(appointmentDateTime));

            return Container(
              height: 180.0,
              margin: const EdgeInsets.all(8.0),
              child: Card(
                child: Row(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: SizedBox(
                        height: 150.0,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(doctor.imagePath ?? ''),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "      ${doctor.fullName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("          ${doctor.specialization}"),
                        Text("          ${doctor.hospitalName}"),
                        Text("          ${doctor.contact}"),
                        Text("         Time: $formattedDateTime"),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text("DELETE"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the currently logged-in user
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text('User not logged in'),
      );
    }

    // Query the appointments collection for the logged-in patient's appointments
    final CollectionReference appointmentsCollection =
    FirebaseFirestore.instance.collection('appointments');

    return StreamBuilder<QuerySnapshot>(
      stream: appointmentsCollection
          .where('patient.id', isEqualTo: currentUser.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching appointments'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<DocumentSnapshot> appointments = snapshot.data!.docs;

        if (appointments.isEmpty) {
          return const Center(
            child: Text('No past appointments'),
          );
        }

        final List<DocumentSnapshot> pastAppointments = [];

        // Separate past appointments
        final currentDate = DateTime.now();
        for (final appointment in appointments) {
          final appointmentDateTime = appointment['appointmentDateTime'] as String;
          final parsedDateTime = DateTime.parse(appointmentDateTime);
          if (parsedDateTime.isBefore(currentDate)) {
            pastAppointments.add(appointment);
          }
        }

        return ListView.builder(
          itemCount: pastAppointments.length,
          itemBuilder: (ctx, index) {
            final appointment = pastAppointments[index].data() as Map<String, dynamic>;
            final doctorData = appointment['doctor'] as Map<String, dynamic>;
            final doctor = Doctor.fromJson(doctorData);

            final appointmentDateTime = appointment['appointmentDateTime'] as String;
            final formattedDateTime = DateFormat('yyyy-MM-dd ' 'hh:mm').format(DateTime.parse(appointmentDateTime));

            return Container(
              height: 180.0,
              margin: const EdgeInsets.all(8.0),
              child: Card(
                child: Row(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: SizedBox(
                        height: 150.0,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(doctor.imagePath ?? ''),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "      ${doctor.fullName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("          ${doctor.specialization}"),
                        Text("          ${doctor.hospitalName}"),
                        Text("          ${doctor.contact}"),
                        Text("         Time: $formattedDateTime"),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text("DELETE"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
