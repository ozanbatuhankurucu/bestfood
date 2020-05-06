import 'package:flutter/material.dart';

class TFField extends StatelessWidget {
  final Function function;
  final String labelText;
  final IconData iconData;
  final Function onChangedFunction;
  TFField(
      {this.function, this.labelText, this.iconData, this.onChangedFunction});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChangedFunction,
      validator: function,
      decoration: InputDecoration(
          prefixIcon: Icon(iconData),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          )),
    );
  }
}
