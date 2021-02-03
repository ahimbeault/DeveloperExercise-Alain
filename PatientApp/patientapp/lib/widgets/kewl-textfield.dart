import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KewlTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final double minWidth;
  final double maxWidth;
  final Function(String) onChanged;
  final Function(String) onValidate;
  final TextEditingController textController;
  final Icon prefixIcon;
  final EdgeInsets margin;
  final EdgeInsets textPadding;
  final int maxTextCharacters;
  final bool displayMaxCharacterValidation;
  final bool digitsOnly;
  final bool enabled;

  KewlTextField({
    String labelText = '',
    String hintText = '',
    double minWidth = 0.0,
    double maxWidth = double.infinity,
    Function(String) onChanged,
    Function(String) onValidate,
    TextEditingController textController,
    Icon prefixIcon = const Icon(null),
    EdgeInsets margin = const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
    EdgeInsets textPadding = const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
    int maxTextCharacters = 50,
    bool displayMaxCharacterValidation = false,
    bool digitsOnly = false,
    bool enabled = true,
  })  : this.labelText = labelText,
        this.hintText = hintText,
        this.minWidth = minWidth,
        this.maxWidth = maxWidth,
        this.onChanged = onChanged,
        this.onValidate = onValidate,
        this.textController = textController,
        this.prefixIcon = prefixIcon,
        this.margin = margin,
        this.textPadding = textPadding,
        this.maxTextCharacters = maxTextCharacters,
        this.displayMaxCharacterValidation = displayMaxCharacterValidation,
        this.digitsOnly = digitsOnly,
        this.enabled = enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
      margin: margin,
      child: TextFormField(
        controller: textController,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: textPadding,
          hintText: hintText,
          labelText: labelText,
          prefixIcon: prefixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.pink),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        validator: onValidate,
        maxLength: (displayMaxCharacterValidation) ? maxTextCharacters : null,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxTextCharacters),
          if (digitsOnly) FilteringTextInputFormatter.digitsOnly,
        ],
        enabled: enabled,
      ),
    );
  }
}
