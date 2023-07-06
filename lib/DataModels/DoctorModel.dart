class Doctor {
  String? id;
  String? fullName;
  String? gender;
  String? hospitalName;
  String? contact;
  String? email;
  String? specialization;
  String? imagePath;

  Doctor({
    this.id,
    this.fullName,
    this.gender,
    this.hospitalName,
    this.contact,
    this.email,
    this.specialization,
    this.imagePath,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      fullName: json['fullName'],
      gender: json['gender'],
      hospitalName: json['hospitalName'],
      contact: json['contact'],
      email: json['email'],
      specialization: json['specialization'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'gender': gender,
      'hospitalName': hospitalName,
      'contact': contact,
      'email': email,
      'specialization': specialization,
      'imagePath': imagePath,
    };
  }
}
