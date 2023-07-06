import 'package:flutter/material.dart';

class DoctorBooking extends StatelessWidget {
  const DoctorBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height/4,
          decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)
              )
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("  Hi, Paitent Name",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),),
                  CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Text("  Appointment List",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35
                ),)
            ],
          ),
        ),
        SizedBox(height: 20,),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              // Doctor doctor = doctors[index];

              return Container(

                height: 150.0,
                margin: const EdgeInsets.all(8.0),
                child:  Card(
                  child: Row(
                    children: [
                      SizedBox(
                          height: 150.0, // Half of the card's height
                          child:  Container(
                            width: 150.0,
                            decoration: const BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(3),
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(3),
                                  bottomRight: Radius.circular(5),
                                )
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 80.0,
                              color: Colors.lightGreen,// Half of the card's width
                            ),
                          )
                      ),
                      const SizedBox(height: 10,),
                      const Column(
                        children: [
                          Text("      doctor.fullName",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),),
                          SizedBox(height: 10,),
                          Text("  doctor.specialization"),
                          Text("  doctor.hospitalName"),
                          Text("  doctor.contact"),
                        ],
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
