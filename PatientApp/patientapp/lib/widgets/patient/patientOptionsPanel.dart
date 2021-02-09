import 'package:flutter/material.dart';
import 'package:patientapp/widgets/patient/patientBody.dart';
import 'package:patientapp/models/patient.dart';
import 'package:patientapp/widgets/patient/addPatientDialog.dart';
import 'package:patientapp/widgets/shared/kewl-textfield.dart';
import 'package:patientapp/api services/api-patient.dart';

class OptionPanel extends StatefulWidget {
  @override
  _OptionPanelState createState() => _OptionPanelState();
}

class _OptionPanelState extends State<OptionPanel> {
  TextEditingController _searchboxController = new TextEditingController();
  bool _includeDeleted = false;
  String _searchText = '';

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
              textController: _searchboxController,
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
                value: _includeDeleted,
                onChanged: (value) {
                  setState(() {
                    _includeDeleted = !_includeDeleted;
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
    Future<List<Patient>> patients = searchPatients(_includeDeleted, text);
    setState(() {
      _searchText = text;
    });
    // Tell the parent its data has changed and force a re-render
    PatientData.of(context).setPatients(patients, null);
  }

  void includeDeletedChanged() {
    Future<List<Patient>> patients =
        searchPatients(_includeDeleted, _searchText);

    // Tell the parent its data has changed and force a re-render
    PatientData.of(context).setPatients(patients, null);
    PatientData.of(context).setIncludeDeleted(_includeDeleted);
  }
}
