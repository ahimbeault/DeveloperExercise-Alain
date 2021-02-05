import 'package:patientapp/models/patient.dart';
import 'package:patientapp/models/phone.dart';
import 'package:patientapp/api services/api-patient.dart';
import 'package:patientapp/widgets/patient/patientList.dart';
import 'package:patientapp/widgets/patient/patientOptionsPanel.dart';
import 'package:patientapp/widgets/patient/patientDetails.dart';
import 'package:flutter/material.dart';

class PatientData extends StatefulWidget {
  static _PatientDataState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PatientDataWidget>()
        .patientData;
  }

  @override
  _PatientDataState createState() => _PatientDataState();
}

class _PatientDataState extends State<PatientData> {
  bool _includeDeleted = false;
  Future<List<Patient>> _patients;
  Patient _currentPatient;

  Patient get getCurrentPatient => _currentPatient;

  @override
  void initState() {
    _patients = getPatients(_includeDeleted);
    List<Phone> phones = [];
    _currentPatient = new Patient(
      firstName: '',
      lastName: '',
      email: '',
      isDeleted: false,
      phones: phones,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PatientDataWidget(
      child: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                height: 50,
                child: OptionPanel(),
              ),
              Divider(
                color: Colors.blue,
                thickness: 4.0,
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: FutureBuilder<List<Patient>>(
                        future: _patients,
                        builder: (context, snapshot) {
                          Widget retval = loading();
                          if (snapshot.hasData) {
                            if (snapshot.data.isEmpty) {
                              retval = Text('No Data Found');
                            } else {
                              retval = PatientList(
                                patients: snapshot.data,
                                currentPatient: _currentPatient,
                              );
                            }
                          } else if (snapshot.hasError) {
                            retval = Text('No Data Found');
                          }
                          return retval;
                        },
                      ),
                    ),
                    PatientDetails(currentPatient: this._currentPatient),
                  ],
                ),
              ),
            ]),
      ),
      patientData: this,
    );
  }

  void refreshPatients() {
    setState(() {
      _patients = getPatients(_includeDeleted);
    });
  }

  void refreshCurrentPatient() async {
    Patient patient = await getPatient(_currentPatient.patientId);
    setState(() {
      _currentPatient = patient;
    });
  }

  void updatePatient(Patient patient) {
    setState(() {
      _patients = getPatients(_includeDeleted);
      _currentPatient = patient;
    });
  }

  void setCurrentPatient(Patient patient) {
    setState(() {
      _currentPatient = patient;
    });
  }

  void setPatients(Future<List<Patient>> patients, Patient currentPatient) {
    setState(() {
      this._patients = patients;
      if (currentPatient != null) {
        this._currentPatient = currentPatient;
      }
    });
  }

  Widget loading() {
    return Container(
      width: 300.0,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 30.0,
            ),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

class PatientDataWidget extends InheritedWidget {
  final _PatientDataState patientData;
  PatientDataWidget({
    Widget child,
    this.patientData,
  }) : super(child: child);

  @override
  bool updateShouldNotify(PatientDataWidget oldWidget) {
    return true;
  }
}
