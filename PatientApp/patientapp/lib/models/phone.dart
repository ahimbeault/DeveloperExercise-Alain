import 'package:flutter_guid/flutter_guid.dart';
import 'package:patientapp/classes/enumerations.dart';
import 'package:flutter/material.dart';

class Phone {
  Guid phoneId;
  PhoneType phoneType;
  String phoneNumber;
  Guid patientId;

  Phone({
    Guid phoneId,
    @required PhoneType phoneType,
    @required String phoneNumber,
    Guid patientId,
  })  : this.phoneId = phoneId,
        this.phoneType = phoneType,
        this.phoneNumber = phoneNumber,
        this.patientId = patientId;

  factory Phone.fromJson(Map<String, dynamic> json) {
    PhoneType phoneType;
    int phoneTypeInt = json['phoneType'];
    switch (phoneTypeInt) {
      case 0:
        phoneType = PhoneType.Cell;
        break;
      case 1:
        phoneType = PhoneType.Home;
        break;
      case 2:
        phoneType = PhoneType.Work;
        break;
      default:
        phoneType = PhoneType.Cell;
        break;
    }

    Phone phone = new Phone(
      phoneId: new Guid(json['phoneId']),
      phoneType: phoneType,
      phoneNumber: json['phoneNumber'],
      patientId: new Guid(json['patientId']),
    );

    return phone;
  }

  Map<String, dynamic> toJson() {
    String phoneTypeString;
    if (phoneType == PhoneType.Cell) {
      phoneTypeString = '0';
    } else if (phoneType == PhoneType.Home) {
      phoneTypeString = '1';
    } else {
      phoneTypeString = '2';
    }

    return {
      if (phoneId != null) 'phoneId': phoneId.toString() else 'phoneId': null,
      'phoneType': phoneTypeString,
      'phoneNumber': phoneNumber,
      'patientId': patientId.toString(),
    };
  }
}
