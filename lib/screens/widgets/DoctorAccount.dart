import 'package:doctor_hunt/screens/AboutPage.dart';
import 'package:flutter/material.dart';

class DoctorAccount extends StatelessWidget {
  const DoctorAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Account'),
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
              onTap: () {
                // Handle Item 3 tap
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              const CircleAvatar(
                radius: 80,
                child: Icon(Icons.person),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
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
                        text = "Your Name";
                      } else if (index == 1) {
                        icon = Icons.info;
                        text = "Hospital";
                      } else if (index == 2) {
                        icon = Icons.phone;
                        text = "Contact";
                      }
                      else{
                        icon = Icons.info;
                        text = "Specialization";
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
                    itemCount: 4,
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
