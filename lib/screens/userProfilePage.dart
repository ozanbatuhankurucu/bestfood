import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:thebestfoodsql/screens/userFollowedLP.dart';
import 'package:thebestfoodsql/screens/userFollowersLP.dart';

class UserProfilePage extends StatefulWidget {
  final uid;
  final token;

  UserProfilePage({this.uid, this.token});
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  var user;
  @override
  void initState() {
    super.initState();
    getUserProfileInfo();
  }

  getUserProfileInfo() async {
    final response = await http.get(
      'http://bestfood.codes2.com/profile?id=${widget.uid}',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        user = json.decode(response.body);
        print('userprofildeym');
        print(user);
      });
    } else {
      print(response.statusCode);
      throw Exception('Aranan kullanıcılar getirilemedi!');
    }
  }

  _onAlertButtonsPressed(context) {
    Alert(
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
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: user == null ? Container() : Text(user['user']['username']),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.message),
      ),
      body: user == null
          ? Center(
              child: SpinKitCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            getCurrentButton(user['relationship']),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  user['user']['picture'],
                                ),
                                radius: 40.0,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        user['follower_count'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        user['following_count'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text('Gönderi'),
                                      GestureDetector(
                                          onTap: () {
                                            if (user['relationship']['state'] ==
                                                true) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserFollowersLPage(
                                                            token: widget.token,
                                                            uid: user['user']['id'])),
                                              );
                                            }
                                          },
                                          child: Text('Takipçi')),
                                      GestureDetector(
                                          onTap: () {
                                            if (user['relationship']['state'] ==
                                                true) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserFollowedLPage(
                                                            token: widget.token,
                                                            uid: user['user']['id'])),
                                              );
                                            }
                                          },
                                          child: Text('Takip edilen'))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(user['user']['firstname'] +
                                        " " +
                                        user['user']['lastname'])
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Widget getCurrentButton(var relationship) {
  Widget button;
  if (relationship == null) {
    button = getButton('Takip et');
    print(relationship);
  } else {
    if (relationship['state'] == true) {
      print(relationship);
      button = getButton('Takip ediliyor');
    } else {
      print(relationship);
      button = getButton('İstek gönderildi');
    }
  }
  return button;
}

Widget getButton(String buttonText) {
  return FlatButton(
      color: Colors.red,
      onPressed: () {},
      child: Text(
        buttonText,
        style: TextStyle(color: Colors.white),
      ),
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)));
}
