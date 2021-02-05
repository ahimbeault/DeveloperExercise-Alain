import 'dart:convert';
import 'package:dio/dio.dart' as dioHttp;
import 'package:patientapp/classes/enumerations.dart';
import 'package:patientapp/models/patient.dart';
import 'package:patientapp/api services/api-services.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:patientapp/environment.dart';

Future<List<Patient>> getPatients(bool includeDeleted) async {
  List<Patient> retval;

  try {
    String url =
        BASE_URL + 'patient?includeDeleted=' + includeDeleted.toString();

    dioHttp.Response response = await executeRequest(url, HttpMethod.GET, null);

    if (response != null && response.statusCode == 200) {
      retval = (response.data as List)
          .map((patient) => new Patient.fromJson(patient))
          .toList();
    } else {
      throw Exception('Failed to get Patients');
    }
  } catch (e) {
    throw Exception(e);
  }

  return retval;
}

Future<Patient> getPatient(Guid patientId) async {
  Patient retval;

  try {
    String url = BASE_URL + 'patient?patientId=' + patientId.toString();

    dioHttp.Response response = await executeRequest(url, HttpMethod.GET, null);

    if (response != null && response.statusCode == 200) {
      retval = (response.data as List)
          .map((patient) => new Patient.fromJson(patient))
          .toList()
          .first;
    } else {
      throw Exception('Failed to get Patient');
    }
  } catch (e) {
    throw Exception(e);
  }

  return retval;
}

Future<List<Patient>> searchPatients(bool includeDeleted, String search) async {
  List<Patient> retval;

  try {
    String url = BASE_URL +
        'patient?includeDeleted=' +
        includeDeleted.toString() +
        '&search=' +
        search;

    dioHttp.Response response = await executeRequest(url, HttpMethod.GET, null);

    if (response != null && response.statusCode == 200) {
      retval = (response.data as List)
          .map((patient) => new Patient.fromJson(patient))
          .toList();
    } else {
      throw Exception('Failed to get Patients');
    }
  } catch (e) {
    throw Exception(e);
  }

  return retval;
}

Future<bool> postPatient(Patient patient) async {
  bool retval = false;
  try {
    String url = BASE_URL + 'patient';
    dioHttp.Response response =
        await executeRequest(url, HttpMethod.POST, json.encode(patient));

    if (response != null && response.statusCode == 200) {
      retval = true;
    }
  } catch (Exception) {
    print(Exception);
    print('Failed to post Patient');
  }

  return retval;
}

Future<bool> putPatient(Patient patient) async {
  bool retval = false;
  try {
    String url = BASE_URL + 'patient';
    dioHttp.Response response =
        await executeRequest(url, HttpMethod.PUT, json.encode(patient));

    if (response != null && response.statusCode == 200) {
      retval = true;
    }
  } catch (Exception) {
    print(Exception);
    print('Failed to update Patient');
  }

  return retval;
}

Future<bool> deletePatient(Patient patient) async {
  bool retval = false;

  try {
    String url = BASE_URL + 'patient/' + patient.patientId.toString();

    dioHttp.Response response =
        await executeRequest(url, HttpMethod.DELETE, null);

    // Process the result
    if (response != null && response.statusCode == 200) {
      retval = true;
    }
  } catch (Exception) {
    print(Exception);
    print('Failed to Delete patient');
  }

  return retval;
}
