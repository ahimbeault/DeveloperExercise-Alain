import 'package:flutter_guid/flutter_guid.dart';
import 'package:patientapp/models/phone.dart';

class Patient {
  Guid patientId;
  String firstName;
  String lastName;
  String email;
  bool isDeleted;
  List<Phone> phones;

  Patient({
    this.patientId,
    this.firstName,
    this.lastName,
    this.email,
    this.isDeleted,
    this.phones,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    List<Phone> phones =
        (json['phones'] as List).map((phone) => Phone.fromJson(phone)).toList();
    Patient patient = new Patient(
      patientId: new Guid(json['patientId']),
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      isDeleted: json['isDeleted'],
    );

    patient.phones = phones;
    return patient;
  }

  Map<String, dynamic> toJson() {
    if (patientId != null) {
      return {
        'patientId': patientId.toString(),
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'isDeleted': isDeleted,
      };
    } else {
      return {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'isDeleted': isDeleted,
      };
    }
  }
}
