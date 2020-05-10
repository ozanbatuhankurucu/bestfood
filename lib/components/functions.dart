import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Functions {
   _onAlertButtonsPressed(context, Function function, var token, var uid) {
    return Alert(
      context: context,
      title: "",
      desc: "Takibi bırakmak istediğinize emin misiniz?",
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            "Vazgeç",
            style: TextStyle(color: Color(0xFF46827F), fontSize: 12),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        DialogButton(
          color: Colors.white,
          child: Text(
            "Takibi Bırak",
            style: TextStyle(color: Color(0xFF46827F), fontSize: 12),
          ),
          onPressed: function,
        )
      ],
    ).show();
  }
   void alertRemoveFollow(context,Function function,var token,var uid){
    _onAlertButtonsPressed(context, function, token, uid);
  }
}
