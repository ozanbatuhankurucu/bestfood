import 'package:flutter/material.dart';

class TFFieldPost extends StatelessWidget {
  final String title;
  final Function function;
  final String labelText;
  final Function onChangedFunction;
  final int maxLine;
  TFFieldPost(
      {this.function,
      this.labelText,
      this.onChangedFunction,
      this.title,
      this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(color: Color(0xFF6C6C6C)),
            ),
          ],
        ),
        TextFormField(
          style: TextStyle(fontSize: 16.0),
          onChanged: onChangedFunction,
          validator: function,
          maxLines: maxLine,
        ),
      ],
    );
  }
}
