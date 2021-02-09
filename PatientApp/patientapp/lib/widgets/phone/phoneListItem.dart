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
    bool isEditing = PatientPhones.of(context).getIsEditing();

    if (currentSelectedPhone == null ||
        (!isEditing && currentSelectedPhone.phoneId != _phone.phoneId)) {
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
          Flexible(
            flex: 1,
            child: Container(
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
          ),
          Flexible(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: KewlTextField(
                labelText: 'Phone Number',
                hintText: 'Enter phone number',
                minWidth: 50,
                maxWidth: 200,
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.indigo,
                ),
                textController: _phoneTextController,
                onChanged: onPhoneChanged,
                onValidate: validatePhoneNumber,
                onFocus: phoneNumberFocus,
                onLostFocus: phoneNumberLostFocus,
                margin: EdgeInsets.only(bottom: 15.0),
                maxTextCharacters: 10,
                displayMaxCharacterValidation: false,
                digitsOnly: true,
                enabled: _isEnabled,
              ),
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

  void phoneNumberLostFocus(String phoneNumber) {
    String newValue;
    if (phoneNumber.isNotEmpty && phoneNumber.length == 10) {
      StringBuffer newText = StringBuffer();
      newText.write('(' + phoneNumber.substring(0, 3) + ') ');
      newText.write(phoneNumber.substring(3, 6) + '-');
      newText.write(phoneNumber.substring(6, 10));
      newValue = newText.toString();
      setState(
          () => {_phoneTextController = TextEditingController(text: newValue)});
    }
  }

  void phoneNumberFocus() {
    String newValue;
    String phoneNumber = _phone.phoneNumber;
    newValue = phoneNumber.replaceAll(new RegExp("[^\\d]"), "");
    setState(
        () => {_phoneTextController = TextEditingController(text: newValue)});
  }
}
