import 'package:flutter/material.dart';
import 'package:patientapp/classes/patientData.dart';
import 'package:patientapp/models/patient.dart';
import 'package:patientapp/classes/addPatientDialog.dart';
import 'package:patientapp/widgets/kewl-textfield.dart';
import 'package:patientapp/api services/api-patient.dart';

class OptionPanel extends StatefulWidget {
  @override
  _OptionPanelState createState() => _OptionPanelState();
}

class _OptionPanelState extends State<OptionPanel> {
  TextEditingController searchboxController = new TextEditingController();
  bool includeDeleted = false;
  String searchText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 50,
              child: IconButton(
                icon: Icon(Icons.add_circle_outline_sharp),
                tooltip: 'Add new Patient',
                onPressed: () {
                  addPatient(context);
                },
              ),
            ),
            KewlTextField(
              labelText: 'Search',
              hintText: 'Search for patient',
              minWidth: 300,
              maxWidth: 300,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              textController: searchboxController,
              margin: EdgeInsets.only(bottom: 15.0),
              onChanged: searchTextChanged,
              maxTextCharacters: 50,
              displayMaxCharacterValidation: false,
            ),
            Container(
              width: 300.0,
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('Include Deleted'),
                value: includeDeleted,
                onChanged: (value) {
                  setState(() {
                    includeDeleted = !includeDeleted;
                    includeDeletedChanged();
                  });
                },
              ),
            ),
          ]),
    );
  }

  void addPatient(BuildContext context) async {
    Patient newPatient;

    newPatient = await showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.3),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform(
            transform: Matrix4.translationValues(0.0, 200, 0.0),
            child: AddPatientDialog(),
          );
        },
        transitionDuration: Duration(milliseconds: 400),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return SizedBox(height: 20.0);
        });

    //tell parent data has changed
    if (newPatient != null) {
      PatientData.of(context).refreshPatients();
    }
  }

  void searchTextChanged(text) {
    Future<List<Patient>> patients = searchPatients(includeDeleted, text);
    setState(() {
      searchText = text;
    });
    // Tell the parent its data has changed and force a re-render
    PatientData.of(context).setPatients(patients, null);
  }

  void includeDeletedChanged() {
    Future<List<Patient>> patients = searchPatients(includeDeleted, searchText);

    // Tell the parent its data has changed and force a re-render
    PatientData.of(context).setPatients(patients, null);
  }
}
