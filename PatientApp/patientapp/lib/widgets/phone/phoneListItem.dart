import 'package:patientapp/models/phone.dart';
import 'package:patientapp/widgets/shared/kewl-textfield.dart';
import 'package:patientapp/classes/enumerations.dart';
import 'package:patientapp/widgets/phone/patientPhones.dart';
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
  String _dropdownValue;
  TextEditingController _phoneTextController;
  Phone _phone;
  bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _phone = new Phone(
      phoneId: widget.phone.phoneId,
      phoneNumber: widget.phone.phoneNumber,
      phoneType: widget.phone.phoneType,
      patientId: widget.phone.patientId,
    );

    if (_phone.phoneType == PhoneType.Home) {
      _dropdownValue = 'Home';
    } else if (_phone.phoneType == PhoneType.Work) {
      _dropdownValue = 'Work';
    } else {
      _dropdownValue = 'Cell';
    }

    _isEnabled = false;
    if (widget.currentSelectedPhone != null) {
      if (widget.currentSelectedPhone.phoneId == _phone.phoneId) {
        _isEnabled = true;
      }
    }

    _phoneTextController = TextEditingController(text: _phone.phoneNumber);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Phone currentSelectedPhone =
        PatientPhones.of(context).getCurrentSelectedPhone();

    if (currentSelectedPhone == null ||
        currentSelectedPhone.phoneId != _phone.phoneId) {
      _phone = new Phone(
        phoneId: widget.phone.phoneId,
        phoneNumber: widget.phone.phoneNumber,
        phoneType: widget.phone.phoneType,
        patientId: widget.phone.patientId,
      );
      if (_phone.phoneType == PhoneType.Home) {
        _dropdownValue = 'Home';
      } else if (_phone.phoneType == PhoneType.Work) {
        _dropdownValue = 'Work';
      } else {
        _dropdownValue = 'Cell';
      }
      _isEnabled = false;
      _phoneTextController = TextEditingController(text: _phone.phoneNumber);
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
              value: _dropdownValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 10,
              onChanged: (_isEnabled)
                  ? (String newValue) {
                      onDropdownChanged(newValue);
                      setState(() => {_dropdownValue = newValue});
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
              textController: _phoneTextController,
              onChanged: onPhoneChanged,
              onValidate: validatePhoneNumber,
              margin: EdgeInsets.only(bottom: 15.0),
              maxTextCharacters: 10,
              displayMaxCharacterValidation: false,
              digitsOnly: true,
              enabled: _isEnabled,
            ),
          ),
        ],
      ),
      onTap: () => {onTappedItem()},
    );
  }

  String validatePhoneNumber(String value) {
    String retval;

    if (value != _phone.phoneNumber) {
      _phone.phoneNumber = value;
    }
    return retval;
  }

  void onDropdownChanged(String value) {
    if (value == 'Cell') {
      _phone.phoneType = PhoneType.Cell;
    } else if (value == 'Home') {
      _phone.phoneType = PhoneType.Home;
    } else {
      _phone.phoneType = PhoneType.Work;
    }

    PatientPhones.of(context).setIsEditing(true);

    if (_phone.phoneNumber.length >= 10) {
      PatientPhones.of(context).setSaveEnabled(true);
      PatientPhones.of(context).setCurrentSelectedPhone(_phone);
    } else {
      PatientPhones.of(context).setSaveEnabled(false);
    }
  }

  void onPhoneChanged(String value) {
    _phone.phoneNumber = value;
    PatientPhones.of(context).setIsEditing(true);
    if (value.length >= 10) {
      PatientPhones.of(context).setSaveEnabled(true);
      PatientPhones.of(context).setCurrentSelectedPhone(_phone);
    } else {
      PatientPhones.of(context).setSaveEnabled(false);
    }
  }

  void onTappedItem() {
    bool isEditing = PatientPhones.of(context).getIsEditing();

    if (!isEditing && !_isEnabled) {
      PatientPhones.of(context).setCurrentSelectedPhone(_phone);
      setState(() => {_isEnabled = true});
    }
  }
}
