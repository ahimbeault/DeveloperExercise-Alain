import 'package:flutter/material.dart';
import 'package:patientapp/classes/enumerations.dart';
import 'package:patientapp/classes/patientData.dart';
import 'package:patientapp/models/patient.dart';
import 'package:patientapp/models/phone.dart';
import 'package:patientapp/api services/api-phone.dart';
import 'package:patientapp/widgets/phoneListItem.dart';
import 'package:flutter_guid/flutter_guid.dart';

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
  Phone currentSelectedPhone;
  bool isEditing;
  bool saveEnabled;

  bool getIsEditing() {
    return isEditing;
  }

  Phone getCurrentSelectedPhone() {
    return currentSelectedPhone;
  }

  void setCurrentSelectedPhone(Phone phone) {
    setState(() => {currentSelectedPhone = phone});
  }

  void setIsEditing(bool isEditing) {
    setState(() => {this.isEditing = isEditing});
  }

  void setSaveEnabled(bool saveEnabled) {
    setState(() => {this.saveEnabled = saveEnabled});
  }

  void addNewPhone() {
    Patient patient = PatientData.of(context).getCurrentPatient;
    Phone newPhone = new Phone(
      phoneId: Guid('00000000-0000-0000-0000-000000000000'),
      phoneType: PhoneType.Cell,
      phoneNumber: '',
    );
    List<Phone> newPhoneList = List.from(widget.phones);
    newPhoneList.add(newPhone);

    patient.phones = newPhoneList;
    PatientData.of(context).setCurrentPatient(patient);

    setState(() => {
          currentSelectedPhone = newPhone,
          isEditing = true,
          saveEnabled = false,
        });
  }

  void savePhone() async {
    bool saveResult;
    Patient patient;
    String formattedPhoneNumber;

    if (currentSelectedPhone.phoneNumber.length == 10) {
      formattedPhoneNumber =
          formatPhoneNumber(currentSelectedPhone.phoneNumber);
    } else {
      formattedPhoneNumber = currentSelectedPhone.phoneNumber;
    }
    currentSelectedPhone.phoneNumber = formattedPhoneNumber;

    if (currentSelectedPhone.phoneId ==
        Guid('00000000-0000-0000-0000-000000000000')) {
      patient = PatientData.of(context).getCurrentPatient;
      currentSelectedPhone.patientId = patient.patientId;
      //adding new phone
      saveResult = await postPhone(currentSelectedPhone);
    } else {
      //updating phone
      saveResult = await putPhone(currentSelectedPhone);
    }

    if (saveResult) {
      PatientData.of(context).refreshPatients();
      PatientData.of(context).refreshCurrentPatient();
      setState(() => {
            currentSelectedPhone = null,
            isEditing = false,
            saveEnabled = false,
          });
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    String newValue;
    int selectionIndex = 0;

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
          currentSelectedPhone = null,
          isEditing = false,
        });
  }

  void delete() async {
    bool saveResult;

    saveResult = await deletePhone(currentSelectedPhone);
    if (saveResult) {
      PatientData.of(context).refreshPatients();
      PatientData.of(context).refreshCurrentPatient();
      setState(() => {
            currentSelectedPhone = null,
            isEditing = false,
          });
    }
  }

  @override
  void initState() {
    super.initState();
    isEditing = false;
    saveEnabled = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
                    phone: widget.phones[index],
                    currentSelectedPhone: currentSelectedPhone,
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
                    onPressed: (isEditing)
                        ? null
                        : () {
                            addNewPhone();
                          },
                  ),
                  IconButton(
                    icon: Icon(Icons.save),
                    tooltip: 'Save Phone',
                    onPressed: (isEditing && saveEnabled)
                        ? () {
                            savePhone();
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.undo),
                    tooltip: 'Undo',
                    onPressed: (isEditing)
                        ? () {
                            undoChanges();
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    tooltip: 'Delete',
                    onPressed: (!isEditing || currentSelectedPhone == null)
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
}

class PatientPhonesWidget extends InheritedWidget {
  final _PatientPhonesState patientPhones;

  PatientPhonesWidget({Widget child, this.patientPhones}) : super(child: child);

  @override
  bool updateShouldNotify(PatientPhonesWidget oldWidget) {
    return true;
  }
}
