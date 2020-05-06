import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thebestfoodsql/components/rButton.dart';
import 'package:thebestfoodsql/components/tFField.dart';
import 'package:thebestfoodsql/screens/mainPage.dart';
import 'package:thebestfoodsql/screens/registerPage.dart';
import 'package:thebestfoodsql/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thebestfoodsql/utils/tokenProvider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String grantType = 'password';
  String userName;
  String password;
  String errorMessage = "";
  Future<void> fetchLogin() async {
    final http.Response response = await http.post(
      'http://bestfood.codes2.com/token',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': userName,
        'password': password,
        'grant_type': 'password'
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      await Token.addUserToken(data['access_token']);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPage()),
          (Route<dynamic> route) => false);
      print(data);
    } else {
      var data = json.decode(response.body);
      setState(() {
        errorMessage = data['error_description'];
      });
      print(response.statusCode);
      print(response.body);
      throw Exception('Kullanıcı giriş yaparken bir sorun oluştu!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading == true
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 64.0, left: 16.0, right: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TFField(
                        onChangedFunction: (value) {
                          userName = value;
                        },
                        iconData: FontAwesomeIcons.user,
                        labelText: 'Kullanıcı adı',
                        function: (value) {
                          if (value.isEmpty) {
                            return 'Lütfen kullanıcı adınızı giriniz!';
                          }
                          return null;
                        },
                      ),
                      kSizedBoxTwenty,
                      TFField(
                        onChangedFunction: (value) {
                          password = value;
                        },
                        iconData: FontAwesomeIcons.lock,
                        labelText: 'Şifre',
                        function: (value) {
                          if (value.isEmpty) {
                            return 'Lütfen şifrenizi giriniz!';
                          }
                          return null;
                        },
                      ),
                      kSizedBoxTwenty,
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                      kSizedBoxTwenty,
                      RButton(
                        buttonText: 'Giriş yap',
                        function: () async {
                          if (_formKey.currentState.validate()) {
                            await fetchLogin();
                          }
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Şifremi unuttum?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      kSizedBoxTen,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Hesabınız yok mu?"),
                          SizedBox(width: 10.0),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()),
                                    (Route<dynamic> route) => false);
                              },
                              child: Text('Kayıt ol',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
