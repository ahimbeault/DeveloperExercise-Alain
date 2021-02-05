import 'package:flutter/material.dart';

class KewlButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback callback;
  final EdgeInsets margin;
  final bool isDisabled;

  KewlButton({
    @required buttonText,
    @required callback,
    EdgeInsets margin = const EdgeInsets.all(0.0),
    bool isDisabled = false,
  })  : this.buttonText = buttonText,
        this.callback = callback,
        this.margin = margin,
        this.isDisabled = isDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: FlatButton(
        padding: EdgeInsets.all(18.0),
        clipBehavior: Clip.none,
        color: Colors.purple,
        textColor: Colors.yellowAccent,
        disabledTextColor: Colors.black.withOpacity(0.3),
        disabledColor: Colors.purple.withOpacity(0.3),
        hoverColor: Colors.purple.withOpacity(0.3),
        shape: StadiumBorder(),
        onPressed: (isDisabled) ? null : callback,
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
