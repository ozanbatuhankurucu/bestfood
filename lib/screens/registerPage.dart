import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:thebestfoodsql/components/rButton.dart';
import 'package:thebestfoodsql/components/tFField.dart';
import 'package:thebestfoodsql/screens/loginPage.dart';
import 'package:thebestfoodsql/utils/constants.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String name;
  String surName;
  String email;
  String password;
  String userName;
  String successMessage = "";
  String verificationMessage;
  Future<void> fetchRegister() async {
    final http.Response response = await http.post(
      'http://bestfood.codes2.com/register',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstname': name,
        'lastname': surName,
        'username': userName,
        'email': email,
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String errorMessage = data['Error_Message'];
      if (errorMessage == null) {
        setState(() {
          successMessage = 'Kayıt başarılı!';
          print(data);
          print(response.statusCode);
          _formKey.currentState.reset();
        });
      } else {
        if (errorMessage.contains('username')) {
          setState(() {
            verificationMessage =
                'Bu kullanıcı adı sistemde bulunmaktadır!';
          });
        }
        //TODO emailin unique kontrolünü sağla
        print(errorMessage);
      }
    } else {
      print(response.statusCode);
      throw Exception('Kullanıcı kayıt olurken bir hata oluştu.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  kSizedBoxTen,
                  verificationMessage == null
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16.0),
                          child: Text(verificationMessage),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFD239),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                  kSizedBoxTen,
                  TFField(
                    onChangedFunction: (value) {
                      name = value;
                    },
                    function: (value) {
                      if (value.isEmpty) {
                        return 'Lütfen isminizi giriniz!';
                      }
                      return null;
                    },
                    labelText: "İsim",
                    iconData: FontAwesomeIcons.user,
                  ),
                  kSizedBoxTen,
                  TFField(
                    onChangedFunction: (value) {
                      surName = value;
                    },
                    function: (value) {
                      if (value.isEmpty) {
                        return 'Lütfen soyisminizi giriniz!';
                      }
                      return null;
                    },
                    labelText: "Soyisim",
                    iconData: FontAwesomeIcons.user,
                  ),
                  kSizedBoxTen,
                  TFField(
                    onChangedFunction: (value) {
                      userName = value;
                    },
                    function: (value) {
                      if (value.isEmpty) {
                        return 'Lütfen kullanıcı adınızı giriniz!';
                      } else {
                        if (userName.contains(" ")) {
                          return 'Kullanıcı adınız boşluk içermemeli!';
                        } else {
                          return null;
                        }
                      }
                    },
                    labelText: "Kullanıcı adı",
                    iconData: FontAwesomeIcons.user,
                  ),
                  kSizedBoxTen,
                  TFField(
                      onChangedFunction: (value) {
                        email = value;
                      },
                      function: (value) {
                        if (value.isEmpty) {
                          return 'Lütfen email adresinizi giriniz!';
                        }
                        return null;
                      },
                      labelText: 'E mail',
                      iconData: FontAwesomeIcons.at),
                  kSizedBoxTen,
                  TFField(
                    onChangedFunction: (value) {
                      password = value;
                    },
                    function: (value) {
                      if (value.isEmpty) {
                        return 'Lütfen şifrenizi giriniz!';
                      } else {
                        if (value.length < 6) {
                          return 'Şifreniz 6 karakterden az olmamalıdır!';
                        } else {
                          return null;
                        }
                      }
                    },
                    labelText: 'Şifre',
                    iconData: FontAwesomeIcons.lock,
                  ),
                  SizedBox(height: 20.0),
                  RButton(
                    buttonText: 'Kayıt ol',
                    function: () async {
                      if (_formKey.currentState.validate()) {
                        await fetchRegister();
                      }
                    },
                  ),
                  kSizedBoxTen,
                  Text(successMessage, style: TextStyle(color: Colors.green)),
                  kSizedBoxTen,
                  Text('Zaten bir hesabın var mı ?'),
                  FlatButton(
                    child: Text(
                      'Giriş yap',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
