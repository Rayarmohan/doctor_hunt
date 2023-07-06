import 'package:doctor_hunt/screens/widgets/DoctorAccount.dart';
import 'package:doctor_hunt/screens/widgets/DoctorBooking.dart';
import 'package:flutter/material.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _currentSelectedIndex = 0;
  List _pages = [
    DoctorBooking(),
    DoctorAccount(),
  ];


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _pages[_currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentSelectedIndex,
          onTap: (newIndex){
          setState(() {
            _currentSelectedIndex = newIndex;
          });
          },
          items: const [BottomNavigationBarItem(icon: Icon(Icons.book),
          label: "Bookings"),
            BottomNavigationBarItem(icon: Icon(Icons.person),
            label: "Account"),
          ]
      ),
    );
  }
}
