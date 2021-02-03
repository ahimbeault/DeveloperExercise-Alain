import 'package:dio/dio.dart' as dioHttp;
import 'package:patientapp/classes/enumerations.dart';
import 'package:patientapp/models/phone.dart';
import 'package:patientapp/api services/api-services.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'dart:convert';
import 'package:patientapp/environment.dart';

Future<List<Phone>> getPatientPhones(Guid patientId) async {
  List<Phone> retval;
  try {
    String url = 'https://localhost:44317/phone/' + patientId.toString();

    dioHttp.Response response = await executeRequest(url, HttpMethod.GET, null);

    if (response != null && response.statusCode == 200) {
      retval = (response.data as List)
          .map((phone) => new Phone.fromJson(phone))
          .toList();
    } else {
      throw Exception('Failed to get Patients');
    }
  } catch (e) {
    throw Exception(e);
  }

  return retval;
}

Future<bool> postPhone(Phone phone) async {
  bool retval = false;
  try {
    String url = BASE_URL + 'phone';
    phone.phoneId = null;
    dioHttp.Response response =
        await executeRequest(url, HttpMethod.POST, json.encode(phone));

    if (response != null && response.statusCode == 200) {
      retval = true;
    }
  } catch (Exception) {
    print(Exception);
    print('Failed to post Phone');
  }

  return retval;
}

Future<bool> putPhone(Phone phone) async {
  bool retval = false;
  try {
    String url = BASE_URL + 'phone';
    dioHttp.Response response =
        await executeRequest(url, HttpMethod.PUT, json.encode(phone));

    if (response != null && response.statusCode == 200) {
      retval = true;
    }
  } catch (Exception) {
    print(Exception);
    print('Failed to update Phone');
  }

  return retval;
}

Future<bool> deletePhone(Phone phone) async {
  bool retval = false;

  try {
    String url = BASE_URL + 'phone/' + phone.phoneId.toString();

    dioHttp.Response response =
        await executeRequest(url, HttpMethod.DELETE, null);

    // Process the result
    if (response != null && response.statusCode == 200) {
      retval = true;
    }
  } catch (Exception) {
    print(Exception);
    print('Failed to Delete phone');
  }
  return retval;
}
