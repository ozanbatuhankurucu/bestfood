import 'package:flutter/material.dart';

class RButton extends StatelessWidget {
  final Function function;
  final String buttonText;
  RButton({this.buttonText, this.function});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.red,
      onPressed: function,
      child: Container(
          height: 50.0,
          child: Center(
              child: Text(
            buttonText,
            style: TextStyle(color: Colors.white),
          ))),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
    );
  }
}
