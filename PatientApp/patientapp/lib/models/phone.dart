import 'package:flutter_guid/flutter_guid.dart';
import 'package:patientapp/classes/enumerations.dart';
import 'package:patientapp/models/patient.dart';

class Phone {
  Guid phoneId;
  PhoneType phoneType;
  String phoneNumber;
  Guid patientId;

  Phone({
    this.phoneId,
    this.phoneType,
    this.phoneNumber,
    this.patientId,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    Phone phone = new Phone(
      phoneId: new Guid(json['phoneId']),
      phoneNumber: json['phoneNumber'],
      patientId: new Guid(json['patientId']),
    );

    int phoneType = json['phoneType'];
    switch (phoneType) {
      case 0:
        phone.phoneType = PhoneType.Cell;
        break;
      case 1:
        phone.phoneType = PhoneType.Home;
        break;
      case 2:
        phone.phoneType = PhoneType.Work;
        break;
      default:
        phone.phoneType = PhoneType.Cell;
        break;
    }

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

    if (phoneId != null) {
      return {
        'phoneId': phoneId.toString(),
        'phoneType': phoneTypeString,
        'phoneNumber': phoneNumber,
        'patientId': patientId.toString(),
      };
    } else {
      return {
        'phoneType': phoneTypeString,
        'phoneNumber': phoneNumber,
        'patientId': patientId.toString(),
      };
    }
  }
}
