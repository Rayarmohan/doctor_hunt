import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  Image(image: AssetImage('assets/logo.png')),
                  SizedBox(height: 10,),
                  Text("Doctor Hunt",
                    style: TextStyle(fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30,),
                   Text("Doctor Hunt is a convenient and user-friendly application designed to streamline the process of booking doctor appointments online."
                       " With Doctor Hunt, patients can easily schedule appointments with their preferred doctors from the comfort of their homes."
                       " The application caters to two main user roles: doctors and patients.",
                   style: TextStyle(
                     fontSize: 16
                   ),),
                  SizedBox(height: 10,),
                   Text("For patients, Doctor Hunt offers a seamless and hassle-free experience."
                       " They can browse through a comprehensive list of doctors, filtering them based on specialization, location, and availability."
                       " Once they find a suitable doctor, patients can book appointments directly through the app, selecting a convenient date and time slot."
                       " This eliminates the need for patients to make phone calls or visit clinics in person for appointment booking.",
                       style: TextStyle(
                       fontSize: 16
                   )),
                  SizedBox(height: 10,),
                   Text("On the other hand, doctors can efficiently manage their appointments through the Doctor Hunt application."
                       " They have access to a dedicated dashboard where they can view and organize their upcoming appointments."
                       " Doctors can review patient details, manage appointment schedules, and make necessary adjustments as needed."
                       " This centralized system ensures doctors can effectively manage their time and provide quality healthcare services to their patients."
                       ,
                       style: TextStyle(
                           fontSize: 16
                       )),
                  SizedBox(height: 10,),
                   Text("Doctor Hunt empowers patients and doctors alike by leveraging the benefits of online connectivity."
                       " It saves time and effort for patients, enabling them to book appointments with their preferred doctors at their convenience."
                       " Simultaneously, doctors can enhance their practice efficiency by efficiently managing their appointments, ultimately delivering better patient care."
                       " With Doctor Hunt, accessing healthcare services becomes more accessible, streamlined, and user-friendly."
                       ,
                       style: TextStyle(
                           fontSize: 16
                       )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
