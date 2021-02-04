import 'package:patientapp/models/phone.dart';
import 'package:patientapp/widgets/kewl-textfield.dart';
import 'package:patientapp/classes/enumerations.dart';
import 'package:patientapp/widgets/patientPhones.dart';
import 'package:flutter/material.dart';

class PhoneListItem extends StatefulWidget {
  final Phone phone;
  final Phone currentSelectedPhone;

  PhoneListItem({
    Phone phone,
    Phone currentSelectedPhone,
  })  : this.phone = phone,
        this.currentSelectedPhone = currentSelectedPhone;

  @override
  _PhoneListItemState createState() => _PhoneListItemState();
}

class _PhoneListItemState extends State<PhoneListItem> {
  String dropdownValue;
  TextEditingController phoneTextController;
  Phone phone;
  bool isEnabled;

  String validatePhoneNumber(String value) {
    String retval;

    if (value != phone.phoneNumber) {
      phone.phoneNumber = value;
    }
    return retval;
  }

  void onDropdownChanged(String value) {
    print(value);
    if (value == 'Cell') {
      phone.phoneType = PhoneType.Cell;
    } else if (value == 'Home') {
      phone.phoneType = PhoneType.Home;
    } else {
      phone.phoneType = PhoneType.Work;
    }

    PatientPhones.of(context).setIsEditing(true);

    if (phone.phoneNumber.length >= 10) {
      PatientPhones.of(context).setSaveEnabled(true);
      PatientPhones.of(context).setCurrentSelectedPhone(phone);
    } else {
      PatientPhones.of(context).setSaveEnabled(false);
    }
  }

  void onPhoneChanged(String value) {
    phone.phoneNumber = value;
    PatientPhones.of(context).setIsEditing(true);
    if (value.length >= 10) {
      PatientPhones.of(context).setSaveEnabled(true);
      PatientPhones.of(context).setCurrentSelectedPhone(phone);
    } else {
      PatientPhones.of(context).setSaveEnabled(false);
    }
  }

  void onTappedItem() {
    bool isEditing = PatientPhones.of(context).getIsEditing();

    if (!isEditing && !isEnabled) {
      PatientPhones.of(context).setCurrentSelectedPhone(phone);
      setState(() => {isEnabled = true});
    }
  }

  @override
  void initState() {
    super.initState();
    phone = new Phone(
      phoneId: widget.phone.phoneId,
      phoneNumber: widget.phone.phoneNumber,
      phoneType: widget.phone.phoneType,
    );

    if (phone.phoneType == PhoneType.Home) {
      dropdownValue = 'Home';
    } else if (phone.phoneType == PhoneType.Work) {
      dropdownValue = 'Work';
    } else {
      dropdownValue = 'Cell';
    }

    isEnabled = false;
    if (widget.currentSelectedPhone != null) {
      if (widget.currentSelectedPhone.phoneId == phone.phoneId) {
        isEnabled = true;
      }
    }

    phoneTextController = TextEditingController(text: phone.phoneNumber);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Phone currentSelectedPhone =
        PatientPhones.of(context).getCurrentSelectedPhone();

    if (currentSelectedPhone == null ||
        currentSelectedPhone.phoneId != phone.phoneId) {
      phone = widget.phone;
      if (phone.phoneType == PhoneType.Home) {
        dropdownValue = 'Home';
      } else if (phone.phoneType == PhoneType.Work) {
        dropdownValue = 'Work';
      } else {
        dropdownValue = 'Cell';
      }
      isEnabled = false;
      phoneTextController = TextEditingController(text: phone.phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: DropdownButton<String>(
              items: <String>['Cell', 'Home', 'Work']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 10,
              onChanged: (isEnabled)
                  ? (String newValue) {
                      onDropdownChanged(newValue);
                      setState(() => {dropdownValue = newValue});
                    }
                  : null,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: KewlTextField(
              labelText: 'Phone Number',
              hintText: 'Enter phone number',
              minWidth: 200,
              maxWidth: 200,
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.indigo,
              ),
              textController: phoneTextController,
              onChanged: onPhoneChanged,
              onValidate: validatePhoneNumber,
              margin: EdgeInsets.only(bottom: 15.0),
              maxTextCharacters: 10,
              displayMaxCharacterValidation: false,
              digitsOnly: true,
              enabled: isEnabled,
            ),
          ),
        ],
      ),
      onTap: () => {onTappedItem()},
    );
  }
}
