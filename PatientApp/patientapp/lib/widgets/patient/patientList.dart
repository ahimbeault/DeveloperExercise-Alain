import 'package:patientapp/models/patient.dart';
import 'package:patientapp/widgets/patient/patientBody.dart';
import 'package:flutter/material.dart';

class PatientList extends StatefulWidget {
  final List<Patient> patients;
  final Patient currentPatient;
  PatientList({
    @required List<Patient> patients,
    Patient currentPatient,
  })  : this.patients = patients,
        this.currentPatient = currentPatient;

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  Patient _currentPatient;

  @override
  void initState() {
    super.initState();

    if (_currentPatient != null) {
      _currentPatient = widget.currentPatient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        child: ListView.builder(
            padding: const EdgeInsets.all(18.0),
            itemCount: widget.patients.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildPatientRow(widget.patients[index]);
            }),
      ),
    );
  }

  Widget _buildPatientRow(Patient patient) {
    return Container(
      color: (_currentPatient != null &&
              patient.patientId == _currentPatient.patientId)
          ? Colors.blue.withOpacity(0.5)
          : Colors.transparent,
      child: ListTile(
        title: Text(
          patient.firstName + " " + patient.lastName,
        ),
        onTap: () => {
          setCurrentPatient(patient),
        },
      ),
    );
  }

  void setCurrentPatient(Patient patient) {
    //tell parent data has changed
    if (patient != null) {
      PatientData.of(context).setCurrentPatient(patient);
      setState(() {
        _currentPatient = patient;
      });
    }
  }
}
