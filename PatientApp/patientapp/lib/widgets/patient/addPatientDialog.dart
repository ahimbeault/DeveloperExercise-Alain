import 'package:patientapp/models/patient.dart';
import 'package:patientapp/widgets/shared/kewl-textfield.dart';
import 'package:patientapp/widgets/shared/kewl-button.dart';
import 'package:patientapp/api services/api-patient.dart';
import 'package:flutter/material.dart';

class AddPatientDialog extends StatefulWidget {
  @override
  _AddPatientDialogState createState() => _AddPatientDialogState();
}

class _AddPatientDialogState extends State<AddPatientDialog> {
  TextEditingController _firstNameTextController;
  TextEditingController _lastNameTextController;
  Future<bool> _saveResult;
  bool _isDisabled = true;
  bool _isLoading = false;
  Patient _newPatient;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _newPatient = new Patient(
      lastName: '',
    );

    _firstNameTextController = TextEditingController(text: '');
    _lastNameTextController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();

    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Dialog(
            backgroundColor: Colors.black,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 16,
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(0.0),
                margin: EdgeInsets.all(0.0),
                width: 500.0,
                height: 350.0,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Center(
                      child: Text('Add New Patient'),
                    ),
                    Divider(
                      color: Colors.blue,
                      thickness: 2.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50.0, right: 50.0),
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 25.0, top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              KewlButton(
                                buttonText: 'Save',
                                callback: () {
                                  dismissDialog(context, true);
                                },
                                margin: EdgeInsets.only(right: 10.0),
                                isDisabled: _isDisabled,
                              ),
                              KewlButton(
                                buttonText: 'Cancel',
                                callback: () {
                                  dismissDialog(context, false);
                                },
                                margin: EdgeInsets.only(left: 10.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          (_isLoading)
              ? FutureBuilder<bool>(
                  future: _saveResult,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_isLoading) {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.pop(context, _newPatient);
                        }
                      });
                    } else if (snapshot.hasError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_isLoading) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      });
                    }

                    return SizedBox(
                      height: 35.0,
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              : SizedBox(height: 35.0),
        ],
      ),
    );
  }

  String validateFirstName(String value) {
    String retval;
    if (value.isEmpty) {
      _newPatient.firstName = value;
      retval = 'First Name is a required field';
    } else if (value != _newPatient.firstName) {
      _newPatient.firstName = value;
    }
    return retval;
  }

  String validateLastName(String value) {
    String retval;
    if (value.isEmpty) {
      _newPatient.lastName = value;
      retval = 'Last Name is a required field';
    } else if (value != _newPatient.lastName) {
      _newPatient.lastName = value;
    }
    return retval;
  }

  void formDataChanged(String value) {
    setState(() {
      _isDisabled = !_formKey.currentState.validate();
    });
  }

  void dismissDialog(BuildContext context, bool opResult) {
    if (opResult) {
      setState(() {
        _isLoading = true;
      });
      _saveResult = postPatient(_newPatient);
    } else {
      Navigator.pop(context, null);
    }
  }
}
