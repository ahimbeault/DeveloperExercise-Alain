import 'package:patientapp/models/patient.dart';
import 'package:patientapp/widgets/kewl-textfield.dart';
import 'package:patientapp/widgets/kewl-button.dart';
import 'package:patientapp/api services/api-patient.dart';
import 'package:flutter/material.dart';

class AddPatientDialog extends StatefulWidget {
  @override
  _AddPatientDialogState createState() => _AddPatientDialogState();
}

class _AddPatientDialogState extends State<AddPatientDialog> {
  TextEditingController firstNameTextController;
  TextEditingController lastNameTextController;

  Future<bool> saveResult;
  bool isDisabled = true;
  bool isLoading = false;
  Patient newPatient;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    newPatient = new Patient(
      firstName: '',
      lastName: '',
      email: '',
      isDeleted: false,
    );

    firstNameTextController = TextEditingController(text: '');
    lastNameTextController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    super.dispose();

    firstNameTextController.dispose();
    lastNameTextController.dispose();
  }

  String validateFirstName(String value) {
    String retval;
    if (value.isEmpty) {
      newPatient.firstName = value;
      retval = 'First Name is a required field';
    } else if (value != newPatient.firstName) {
      newPatient.firstName = value;
    }
    return retval;
  }

  String validateLastName(String value) {
    String retval;
    if (value.isEmpty) {
      newPatient.lastName = value;
      retval = 'Last Name is a required field';
    } else if (value != newPatient.lastName) {
      newPatient.lastName = value;
    }
    return retval;
  }

  void formDataChanged(String value) {
    setState(() {
      isDisabled = !_formKey.currentState.validate();
    });
  }

  void dismissDialog(BuildContext context, bool opResult) {
    if (opResult) {
      setState(() {
        isLoading = true;
      });
      saveResult = postPatient(newPatient);
    } else {
      Navigator.pop(context, null);
    }
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
                            textController: firstNameTextController,
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
                            textController: lastNameTextController,
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
                                isDisabled: isDisabled,
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
          (isLoading)
              ? FutureBuilder<bool>(
                  future: saveResult,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (isLoading) {
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context, newPatient);
                        }
                      });
                    } else if (snapshot.hasError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (isLoading) {
                          setState(() {
                            isLoading = false;
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
}
