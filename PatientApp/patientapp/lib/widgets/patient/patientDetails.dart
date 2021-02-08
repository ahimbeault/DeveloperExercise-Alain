import 'package:flutter/material.dart';
import 'package:patientapp/models/phone.dart';
import 'package:patientapp/widgets/patient/patientBody.dart';
import 'package:patientapp/models/patient.dart';
import 'package:patientapp/widgets/shared/kewl-textfield.dart';
import 'package:patientapp/widgets/shared/kewl-button.dart';
import 'package:patientapp/api services/api-patient.dart';
import 'package:patientapp/widgets/phone/patientPhones.dart';
import 'package:patientapp/widgets/patient/confirmDeletionDialog.dart';

class PatientDetails extends StatefulWidget {
  final Patient currentPatient;

  PatientDetails({Patient currentPatient})
      : this.currentPatient = currentPatient;

  static _PatientDetailsState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PatientDetailsWidget>()
        .patientDetails;
  }

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  TextEditingController _firstNameTextController;
  TextEditingController _lastNameTextController;
  TextEditingController _emailTextController;
  bool _isDisabled = true;
  Patient _currentPatient;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _currentPatient = new Patient(
      patientId: widget.currentPatient.patientId,
      firstName: widget.currentPatient.firstName,
      lastName: widget.currentPatient.lastName,
      email: widget.currentPatient.email,
      isDeleted: widget.currentPatient.isDeleted,
      phones: widget.currentPatient.phones,
    );

    _firstNameTextController =
        TextEditingController(text: _currentPatient.firstName);

    _lastNameTextController =
        TextEditingController(text: _currentPatient.lastName);

    _emailTextController = TextEditingController(text: _currentPatient.email);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Patient patient;

    // If the parent propogated a change, reflect it in this widget
    patient = PatientData.of(context).getCurrentPatient;

    _currentPatient = new Patient(
      patientId: patient.patientId,
      firstName: patient.firstName,
      lastName: patient.lastName,
      email: patient.email,
      isDeleted: patient.isDeleted,
      phones: patient.phones,
    );

    _firstNameTextController =
        TextEditingController(text: _currentPatient.firstName);

    _lastNameTextController =
        TextEditingController(text: _currentPatient.lastName);

    _emailTextController = TextEditingController(text: _currentPatient.email);
    _isDisabled = true;
  }

  @override
  void dispose() {
    super.dispose();

    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(0.0),
      child: PatientDetailsWidget(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        color: Colors.blue,
                        thickness: 2.0,
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 50.0, right: 50.0),
                          child: Container(
                            padding: EdgeInsets.all(0.0),
                            margin: EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.all(10.0),
                                    child: Text(
                                      'Patient Id: ' +
                                          _currentPatient.patientId.toString(),
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.blue),
                                    )),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Center(child: Text('Status:')),
                                      width: 55.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: (_currentPatient.isDeleted)
                                          ? Center(child: Text('Inactive'))
                                          : Center(child: Text('Active')),
                                      width: 55.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        color: (_currentPatient.isDeleted)
                                            ? Colors.red
                                            : Colors.green,
                                        border: Border.all(
                                          color: (_currentPatient.isDeleted)
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50.0,
                                  width: 500.0,
                                ),
                                KewlTextField(
                                  labelText: 'First Name',
                                  hintText: 'Enter patient\'s first name',
                                  minWidth: 300,
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.indigo,
                                  ),
                                  textController: _firstNameTextController,
                                  margin: EdgeInsets.only(bottom: 15.0),
                                  onValidate: validateFirstName,
                                  onChanged: formDataChanged,
                                  maxTextCharacters: 50,
                                  displayMaxCharacterValidation: true,
                                ),
                                KewlTextField(
                                  labelText: 'Last Name',
                                  hintText: 'Enter patient\'s last name',
                                  minWidth: 300,
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.indigo,
                                  ),
                                  textController: _lastNameTextController,
                                  margin: EdgeInsets.only(bottom: 15.0),
                                  onValidate: validateLastName,
                                  onChanged: formDataChanged,
                                  maxTextCharacters: 50,
                                  displayMaxCharacterValidation: true,
                                ),
                                KewlTextField(
                                  labelText: 'Email',
                                  hintText: 'Enter patient\'s eamil',
                                  minWidth: 300,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.indigo,
                                  ),
                                  textController: _emailTextController,
                                  margin: EdgeInsets.only(bottom: 15.0),
                                  onValidate: validateEmail,
                                  onChanged: formDataChanged,
                                  maxTextCharacters: 50,
                                  displayMaxCharacterValidation: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 25.0, top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              KewlButton(
                                buttonText: 'Save',
                                callback: () {
                                  updatePatient();
                                },
                                margin: EdgeInsets.only(right: 10.0),
                                isDisabled: _isDisabled,
                              ),
                              KewlButton(
                                buttonText: 'Refresh',
                                callback: () {
                                  refreshPatient();
                                },
                                margin:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                isDisabled: _isDisabled,
                              ),
                              KewlButton(
                                buttonText: 'Delete',
                                callback: () {
                                  delete();
                                },
                                margin: EdgeInsets.only(left: 10.0),
                                isDisabled: _currentPatient.isDeleted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(0.0),
                margin: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: Text(
                        'Phones',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    PatientPhones(
                      phones: _currentPatient.phones,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        patientDetails: this,
      ),
    );
  }

  String validateFirstName(String value) {
    String retval;
    if (value.isEmpty) {
      _currentPatient.firstName = value;
      retval = 'First Name is a required field';
    } else if (value != _currentPatient.firstName) {
      _currentPatient.firstName = value;
    }
    return retval;
  }

  String validateLastName(String value) {
    String retval;
    if (value.isEmpty) {
      _currentPatient.lastName = value;
      retval = 'Last Name is a required field';
    } else if (value != _currentPatient.lastName) {
      _currentPatient.lastName = value;
    }
    return retval;
  }

  String validateEmail(String value) {
    String retval;
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      retval = 'Please enter valid email';
    } else if (value != _currentPatient.email) {
      _currentPatient.email = value;
    }
    return retval;
  }

  void formDataChanged(String value) {
    setState(() {
      _isDisabled = !_formKey.currentState.validate();
    });
  }

  void updatePatient() async {
    bool saveResult;
    saveResult = await putPatient(_currentPatient);
    if (saveResult) {
      Future<List<Patient>> patients = searchPatients(false, '');

      // Tell the parent its data has changed and force a re-render
      PatientData.of(context).setPatients(patients, _currentPatient);

      setState(() {
        _isDisabled = true;
      });
    }
  }

  void refreshPatient() {
    PatientData.of(context).refreshCurrentPatient();
  }

  void delete() async {
    bool saveResult;

    saveResult = await showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.3),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform(
            transform: Matrix4.translationValues(0.0, 200, 0.0),
            child: ConfirmDeletionDialog(patient: _currentPatient),
          );
        },
        transitionDuration: Duration(milliseconds: 400),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return SizedBox(height: 20.0);
        });
    if (saveResult) {
      Future<List<Patient>> patients = searchPatients(false, '');

      // Tell the parent its data has changed and force a re-render
      PatientData.of(context).setPatients(patients, _currentPatient);
      PatientData.of(context).refreshCurrentPatient();
      setState(() {
        _isDisabled = true;
      });
    }
  }

  List<Phone> getCurrentPatientPhones() {
    return _currentPatient.phones;
  }
}

class PatientDetailsWidget extends InheritedWidget {
  final _PatientDetailsState patientDetails;
  PatientDetailsWidget({
    Widget child,
    this.patientDetails,
  }) : super(child: child);

  @override
  bool updateShouldNotify(PatientDetailsWidget oldWidget) {
    print('detailsupdatedwoooot');
    return true;
  }
}
