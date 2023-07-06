import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/screens/DoctorLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../DataModels/DoctorModel.dart';

class DoctorRegister extends StatefulWidget {
  const DoctorRegister({Key? key}) : super(key: key);

  @override
  State<DoctorRegister> createState() => _DoctorRegisterState();
}

class _DoctorRegisterState extends State<DoctorRegister> {
  bool _isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _selectedGender;
  String? _selectedSpecial;
  bool _obscureText = true;
  DateTime? _selectedDate;
  final List<String> gender = [
    'Male',
    'Female',
    'Other',
  ];
  final List<String> specialization = [
    'Pediatrician',
    'Cardiology',
    'Dental',
    'ENT',
    'Neurologist',
    'Anesthesiology',
    'Orthopedics',
    'Psychiatrist'
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectImage() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

 Future<void> _register() async{
   if (_formKey.currentState!.validate())
   {
     if (_selectedImage == null) {
       // Handle image not selected
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('Please select a profile image'),
         ),
       );
       return;
     }
     else{
       try {
         setState(() {
           _isLoading = true; // Set loading state to true
         });
         // Step 1: Create the user in Firebase Authentication
         UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
           email: _emailController.text, // Replace with the user's email
           password: _passwordController.text, // Replace with the user's password
         );

         // Step 2: Upload the user's profile image to Firebase Storage
         String userId = userCredential.user!.uid;
         String imageFileName = 'profile_$userId.jpg'; // Unique filename for the image
         TaskSnapshot imageUploadTask = await FirebaseStorage.instance.ref().child('profile_images').child(imageFileName).putFile(_selectedImage!);

         // Step 3: Get the download URL of the uploaded image
         String downloadUrl = await imageUploadTask.ref.getDownloadURL();

         // Step 4: Create a Doctor instance with the user's details
         Doctor doctor = Doctor(
           id: userId,
           fullName: _fullNameController.text, // Replace with the user's full name
           gender: _selectedGender, // Gender selection from the dropdown
           hospitalName: _hospitalNameController.text, // Replace with the hospital name
           contact: _contactController.text, // Replace with the contact details
           email: _emailController.text , // Replace with the user's email
           specialization: _selectedSpecial, // Specialization selection from the dropdown
           imagePath: downloadUrl, // Download URL of the profile image
         );

         // Step 5: Save the doctor's details to Cloud Firestore
         await FirebaseFirestore.instance.collection('doctors').doc(userId).set(doctor.toJson());

         // Registration successful
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('Registration successful'),
           ),
         );

         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>const DoctorLogin()));
       } catch (e) {
         // Registration failed
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('Failed'),
           ),
         );

         return;
       }
       finally
           {
             setState(() {
               _isLoading = false; // Set loading state to false
             });
           }
     }


   }
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
            ? const Center(
        child: CircularProgressIndicator(),
      ) : SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Doctor Registration",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: GestureDetector(
                    onTap: _selectImage,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? const Icon(
                              Icons.person,
                              size: 80,
                            )
                          : null,
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      _selectImage();
                    },
                    child: const Text("UPLOAD IMAGE")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Full Name'),
                    validator: (value){
                      if(value!.isEmpty)
                        {
                          return 'Please Enter Your Name';
                        }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Gender"),
                      value: _selectedGender,
                      items: gender
                          .map(
                            (e) => DropdownMenuItem<String>(
                                value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                        });
                      },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your gender';
                      }
                      return null;
                    },),
                ),
                const SizedBox(
                  height: 10,
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
                            labelText: "Date of Birth",
                            suffixIcon: Icon(Icons.calendar_month_rounded)),
                        controller: TextEditingController(
                          text: _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : '',
                        ),
                        validator: (value){
                          if(value!.isEmpty)
                          {
                            return 'Please Enter Date of Birth';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _hospitalNameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Hospital Name'),
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return 'Please Enter Hospital Name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Contact'),
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return 'Please Enter Contact Number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Email'),
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Perform email validation here
                      // You can use regular expressions or any other method to validate the email format
                      // Example validation using regular expression:
                      final emailRegex =
                      RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'New Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: const Icon(Icons.visibility))),
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: const Icon(Icons.visibility))),
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Specialization"),
                      value: _selectedSpecial,
                      items: specialization
                          .map(
                            (e) => DropdownMenuItem<String>(
                                value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSpecial = newValue;
                        });
                      },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your Specialization';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _register();
                          }, child: const Text('Register')),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
