import 'package:patientapp/models/patient.dart';
import 'package:patientapp/widgets/kewl-textfield.dart';
import 'package:patientapp/widgets/kewl-button.dart';
import 'package:patientapp/api services/api-patient.dart';
import 'package:flutter/material.dart';

class ConfirmDeletionDialog extends StatefulWidget {
  final Patient patient;

  ConfirmDeletionDialog({
    Patient patient,
  }) : this.patient = patient;

  @override
  _ConfirmDeletionDialogState createState() => _ConfirmDeletionDialogState();
}

class _ConfirmDeletionDialogState extends State<ConfirmDeletionDialog> {
  TextEditingController nameTextController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<bool> saveResult;
  bool isDisabled = true;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();

    nameTextController.dispose();
  }

  @override
  void initState() {
    super.initState();

    nameTextController = TextEditingController(text: '');
  }

  void dismissDialog(BuildContext context, bool opResult) {
    if (opResult) {
      setState(() {
        isLoading = true;
      });
      saveResult = deletePatient(widget.patient);
    } else {
      Navigator.pop(context, false);
    }
  }

  String validateName(String value) {
    String retval;
    if (value.isEmpty) {
      retval = 'Enter the patient\'s name';
    } else if (value !=
        widget.patient.firstName + ' ' + widget.patient.lastName) {
      retval = 'Patient name does not match';
    }
    return retval;
  }

  void formDataChanged(String value) {
    setState(() {
      isDisabled = !_formKey.currentState.validate();
    });
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
                height: 300.0,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Center(
                      child: Text('Confirm Deletion'),
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
                            labelText: 'Patient Name',
                            hintText: widget.patient.firstName +
                                ' ' +
                                widget.patient.lastName,
                            minWidth: 300,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.indigo,
                            ),
                            textController: nameTextController,
                            margin: EdgeInsets.only(bottom: 15.0),
                            onValidate: validateName,
                            onChanged: formDataChanged,
                            maxTextCharacters: 110,
                            displayMaxCharacterValidation: false,
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
                                buttonText: 'Delete',
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
                          Navigator.pop(context, true);
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
