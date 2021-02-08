import 'package:flutter/material.dart';
import 'package:patientapp/classes/enumerations.dart';
import 'package:patientapp/widgets/patient/patientBody.dart';
import 'package:patientapp/widgets/patient/patientDetails.dart';
import 'package:patientapp/models/patient.dart';
import 'package:patientapp/models/phone.dart';
import 'package:patientapp/api services/api-phone.dart';
import 'package:patientapp/widgets/phone/phoneListItem.dart';

class PatientPhones extends StatefulWidget {
  final List<Phone> phones;

  PatientPhones({
    List<Phone> phones,
  }) : this.phones = phones;

  static _PatientPhonesState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PatientPhonesWidget>()
        .patientPhones;
  }

  @override
  _PatientPhonesState createState() => _PatientPhonesState();
}

class _PatientPhonesState extends State<PatientPhones> {
  List<Phone> _phones;
  Phone _currentSelectedPhone;
  bool _isEditing;
  bool _saveEnabled;

  @override
  void initState() {
    super.initState();

    _currentSelectedPhone = null;
    _isEditing = false;
    _saveEnabled = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _phones = PatientDetails.of(context).getCurrentPatientPhones();
    _currentSelectedPhone = null;
    _isEditing = false;
    _saveEnabled = false;
    print('phones changed');
  }

  @override
  Widget build(BuildContext context) {
    return PatientPhonesWidget(
      child: Container(
        width: 400,
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(18.0),
                itemCount: widget.phones.length,
                itemBuilder: (BuildContext context, int index) {
                  return PhoneListItem(
                    phone: _phones[index],
                    currentSelectedPhone: _currentSelectedPhone,
                  );
                },
              ),
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.add_circle_outline_sharp),
                    tooltip: 'Add new phone',
                    onPressed: (_isEditing)
                        ? null
                        : () {
                            addNewPhone();
                          },
                  ),
                  IconButton(
                    icon: Icon(Icons.save),
                    tooltip: 'Save Phone',
                    onPressed: (_isEditing && _saveEnabled)
                        ? () {
                            savePhone();
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.undo),
                    tooltip: 'Undo',
                    onPressed: (_isEditing)
                        ? () {
                            undoChanges();
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    tooltip: 'Delete',
                    onPressed: (_isEditing || _currentSelectedPhone == null)
                        ? null
                        : () {
                            delete();
                          },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      patientPhones: this,
    );
  }

  bool getIsEditing() {
    return _isEditing;
  }

  Phone getCurrentSelectedPhone() {
    return _currentSelectedPhone;
  }

  void setCurrentSelectedPhone(Phone phone) {
    setState(() => {_currentSelectedPhone = phone});
  }

  void setIsEditing(bool isEditing) {
    setState(() => {this._isEditing = isEditing});
  }

  void setSaveEnabled(bool saveEnabled) {
    setState(() => {this._saveEnabled = saveEnabled});
  }

  void addNewPhone() {
    Patient patient = PatientData.of(context).getCurrentPatient;
    Phone newPhone = new Phone(
      phoneType: PhoneType.Cell,
      phoneNumber: '',
    );
    List<Phone> newPhoneList = List.from(widget.phones);
    newPhoneList.add(newPhone);

    patient.phones = newPhoneList;
    PatientData.of(context).setCurrentPatient(patient);

    setState(() => {
          _currentSelectedPhone = newPhone,
          _isEditing = true,
          _saveEnabled = false,
        });
  }

  void savePhone() async {
    bool saveResult;
    Patient patient;
    String formattedPhoneNumber;

    if (_currentSelectedPhone.phoneNumber.length == 10) {
      formattedPhoneNumber =
          formatPhoneNumber(_currentSelectedPhone.phoneNumber);
    } else {
      formattedPhoneNumber = _currentSelectedPhone.phoneNumber;
    }
    _currentSelectedPhone.phoneNumber = formattedPhoneNumber;

    if (_currentSelectedPhone.phoneId == null) {
      patient = PatientData.of(context).getCurrentPatient;
      _currentSelectedPhone.patientId = patient.patientId;
      //adding new phone
      saveResult = await postPhone(_currentSelectedPhone);
    } else {
      //updating phone
      saveResult = await putPhone(_currentSelectedPhone);
    }

    if (saveResult) {
      PatientData.of(context).refreshPatients();
      PatientData.of(context).refreshCurrentPatient();
      setState(() => {
            _currentSelectedPhone = null,
            _isEditing = false,
            _saveEnabled = false,
          });
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    String newValue;

    StringBuffer newText = StringBuffer();
    newText.write('(' + phoneNumber.substring(0, 3) + ') ');
    newText.write(phoneNumber.substring(3, 6) + '-');
    newText.write(phoneNumber.substring(6, 10));

    newValue = newText.toString();
    return newValue;
  }

  void undoChanges() {
    PatientData.of(context).refreshCurrentPatient();
    setState(() => {
          _currentSelectedPhone = null,
          _isEditing = false,
        });
  }

  void delete() async {
    bool saveResult;

    saveResult = await deletePhone(_currentSelectedPhone);
    if (saveResult) {
      PatientData.of(context).refreshPatients();
      PatientData.of(context).refreshCurrentPatient();
      setState(() => {
            _currentSelectedPhone = null,
            _isEditing = false,
          });
    }
  }
}

class PatientPhonesWidget extends InheritedWidget {
  final _PatientPhonesState patientPhones;

  PatientPhonesWidget({Widget child, this.patientPhones}) : super(child: child);

  @override
  bool updateShouldNotify(PatientPhonesWidget oldWidget) {
    return true;
  }
}
