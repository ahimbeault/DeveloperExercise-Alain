import 'package:flutter_guid/flutter_guid.dart';
import 'package:patientapp/models/phone.dart';
import 'package:flutter/material.dart';

class Patient {
  Guid patientId;
  String firstName;
  String lastName;
  String email;
  bool isDeleted;
  List<Phone> phones;

  Patient({
    Guid patientId,
    String firstName = '',
    @required String lastName,
    String email = '',
    bool isDeleted = false,
    List<Phone> phones,
  })  : this.patientId = patientId,
        this.firstName = firstName,
        this.lastName = lastName,
        this.email = email,
        this.isDeleted = isDeleted,
        this.phones = phones;

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
    return {
      if (patientId != null) 'patientId': patientId.toString(),
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'isDeleted': isDeleted,
    };
  }
}
