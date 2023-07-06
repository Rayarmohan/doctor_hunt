import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/DataModels/PaitentModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PaitentUpdate extends StatefulWidget {
  const PaitentUpdate({Key? key}) : super(key: key);

  @override
  State<PaitentUpdate> createState() => _PaitentUpdateState();
}

class _PaitentUpdateState extends State<PaitentUpdate> {
  bool _isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _selectedGender;
  DateTime? _selectedDate;
  String? _age;
  final List<String> gender = ['Male', 'Female', 'Other'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
  }

  Future<void> _fetchPatientDetails() async {
    try {
      setState(() {
        _isLoading = true;
      });

      String? userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot patientSnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .get();

      if (patientSnapshot.exists) {
        Patient patient =
        Patient.fromJson(patientSnapshot.data() as Map<String, dynamic>);

        setState(() {
          _fullNameController.text = patient.fullName ?? '';
          _selectedGender = patient.gender;
          _ageController.text = patient.age ?? '';
          _addressController.text = patient.address ?? '';
          _contactController.text = patient.contact ?? '';
          // Fetch and set the patient's image URL here
          _selectedImage =
          patient.imagePath != null ? File(patient.imagePath!) : null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch patient details'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _calculateAge();
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

  void _calculateAge() {
    if (_selectedDate != null) {
      final now = DateTime.now();
      final age = now.year - _selectedDate!.year;
      if (now.month < _selectedDate!.month ||
          (now.month == _selectedDate!.month && now.day < _selectedDate!.day)) {
        _age = (age - 1).toString();
      } else {
        _age = age.toString();
      }
    } else {
      _age = null;
    }
  }

  Future<void> _updatePatientDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      String? userId = FirebaseAuth.instance.currentUser!.uid;
      Patient updatedPatient = Patient(
        fullName: _fullNameController.text.trim(),
        gender: _selectedGender,
        age: _selectedDate != null ? _selectedDate!.toIso8601String() : '',
        address: _addressController.text.trim(),
        contact: _contactController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('patients')
          .doc(userId)
          .update(updatedPatient.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patient details updated successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update patient details'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Patient Registration",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
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
                          ? const Icon(Icons.person, size: 80)
                          : null,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _selectImage,
                  child: const Text("UPLOAD IMAGE"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Full Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
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
                      labelText: "Gender",
                    ),
                    value: _selectedGender,
                    items: gender
                        .map(
                          (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ),
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
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: _age,
                        ),
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
                    controller: _addressController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your address';
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
                      border: OutlineInputBorder(),
                      labelText: 'Contact',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter contact number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _updatePatientDetails,
                        child: const Text('Update'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
