import 'package:doctor_hunt/DataModels/DoctorModel.dart';
import 'package:doctor_hunt/DataModels/PaitentModel.dart';


class Appointment {
  final Doctor doctor;
  final Patient patient;
  final DateTime appointmentDateTime;

  Appointment({
    required this.doctor,
    required this.patient,
    required this.appointmentDateTime,
  });

  // Convert the Appointment object to a JSON representation
  Map<String, dynamic> toJson() {
    return {
      'doctor': doctor.toJson(),
      'patient': patient.toJson(),
      'appointmentDateTime': appointmentDateTime.toIso8601String(),
    };
  }

  // Create an Appointment object from a JSON representation
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      doctor: Doctor.fromJson(json['doctor']),
      patient: Patient.fromJson(json['patient']),
      appointmentDateTime: DateTime.parse(json['appointmentDateTime']),
    );
  }
}
