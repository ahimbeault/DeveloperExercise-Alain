import 'package:patientapp/models/patient.dart';
import 'package:patientapp/models/phone.dart';
import 'package:patientapp/api services/api-patient.dart';
import 'package:patientapp/widgets/patientList.dart';
import 'package:patientapp/widgets/optionsPanel.dart';
import 'package:patientapp/widgets/patientDetails.dart';
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
  bool includeDeleted = false;
  Future<List<Patient>> patients;
  Patient currentPatient;

  Patient get getCurrentPatient => currentPatient;

  @override
  void initState() {
    patients = getPatients(includeDeleted);
    List<Phone> phones = [];
    currentPatient = new Patient(
      firstName: '',
      lastName: '',
      email: '',
      isDeleted: false,
      phones: phones,
    );

    super.initState();
  }

  void refreshPatients() {
    setState(() {
      patients = getPatients(includeDeleted);
    });
  }

  void refreshCurrentPatient() async {
    Patient patient = await getPatient(currentPatient.patientId);
    setState(() {
      currentPatient = patient;
    });
  }

  void updatePatient(Patient patient) {
    setState(() {
      patients = getPatients(includeDeleted);
      currentPatient = patient;
    });
  }

  void setCurrentPatient(Patient patient) {
    setState(() {
      currentPatient = patient;
    });
  }

  void setPatients(Future<List<Patient>> patients, Patient currentPatient) {
    setState(() {
      this.patients = patients;
      if (currentPatient != null) {
        this.currentPatient = currentPatient;
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
                        future: patients,
                        builder: (context, snapshot) {
                          Widget retval = loading();
                          if (snapshot.hasData) {
                            if (snapshot.data.isEmpty) {
                              retval = Text('No Data Found');
                            } else {
                              retval = PatientList(
                                patients: snapshot.data,
                                currentPatient: currentPatient,
                              );
                            }
                          } else if (snapshot.hasError) {
                            retval = Text('No Data Found');
                          }
                          return retval;
                        },
                      ),
                    ),
                    PatientDetails(currentPatient: this.currentPatient),
                  ],
                ),
              ),
            ]),
      ),
      patientData: this,
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
