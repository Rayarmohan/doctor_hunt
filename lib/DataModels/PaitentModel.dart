class Patient {
  String? id;
  String? fullName;
  String? gender;
  String? age;
  String? address;
  String? contact;
  String? email;
  String? imagePath;

  Patient({
    this.id,
    this.fullName,
    this.gender,
    this.age,
    this.address,
    this.contact,
    this.email,
    this.imagePath,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fullName: json['fullName'],
      gender: json['gender'],
      age: json['age'],
      address: json['address'],
      contact: json['contact'],
      email: json['email'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'gender': gender,
      'age': age,
      'address': address,
      'contact': contact,
      'email': email,
      'imagePath': imagePath,
    };
  }
}
