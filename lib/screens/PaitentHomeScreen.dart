import 'package:doctor_hunt/screens/widgets/FavouriteDoctor.dart';
import 'package:doctor_hunt/screens/widgets/PaitentAccount.dart';
import 'package:doctor_hunt/screens/widgets/PaitentBookings.dart';
import 'package:doctor_hunt/screens/widgets/PaitentHome.dart';
import 'package:flutter/material.dart';

class PaitentHomeScreen extends StatefulWidget {
  const PaitentHomeScreen({Key? key}) : super(key: key);

  @override
  State<PaitentHomeScreen> createState() => _PaitentHomeScreenState();
}
int _currentSelectedIndex = 0;
List _pages = [
   PaitentHome(),
  const PaitentBookings(),
  const FavouriteDoctor(),
  const PaitentAccount(),

];

class _PaitentHomeScreenState extends State<PaitentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentSelectedIndex,
          onTap: (newIndex){
          setState(() {
            _currentSelectedIndex = newIndex;
          });
          },
          items: const [ BottomNavigationBarItem(icon: Icon(Icons.home,
          color: Colors.teal,),
            label: 'Home'
          ),
            BottomNavigationBarItem(icon: Icon(Icons.book,
                color: Colors.teal),
              label: 'Bookings'
            ),

            BottomNavigationBarItem(icon: Icon(Icons.favorite,
                color: Colors.teal),
                label: 'Favourite'
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person,
                color: Colors.teal),
                label: 'Account'
            ),
          ]
      ),

    );
  }
}
