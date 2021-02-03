import 'dart:js';
import 'package:dio/dio.dart' as dioHttp;
import 'package:patientapp/classes/enumerations.dart';
import 'package:patientapp/models/patient.dart';
import 'package:patientapp/widgets/optionsPanel.dart';
import 'package:flutter/material.dart';

class PatientTitleBar extends StatefulWidget {
  @override
  _PatientTitleBarState createState() => _PatientTitleBarState();
}

class _PatientTitleBarState extends State<PatientTitleBar> {
  bool _includeDeleted = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OptionPanel(),
          Container(
            width: 300.0,
            child: Text('temp search'),
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
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
