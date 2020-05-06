import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:thebestfoodsql/screens/userProfilePage.dart';

//TODO pagination yapilacak
class FollowedLPage extends StatefulWidget {
  final token;
  FollowedLPage({this.token});
  @override
  _FollowedLPageState createState() => _FollowedLPageState();
}

class _FollowedLPageState extends State<FollowedLPage> {
  var followeds;

  void getFolloweds() async {
    final response = await http.get(
      'http://bestfood.codes2.com/get_following',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        followeds = json.decode(response.body);
      });
      print(followeds);
    } else {
      throw Exception('Takip edilenleri çekerken bir hata meydana geldi!');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFolloweds();
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
        title: Text('Takip edilenler'),
      ),
      body: followeds == null
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            )
          : ListView.builder(
              itemCount: followeds.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                                uid: followeds[index]['id'],
                                token: widget.token,
                              )),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      followeds[index]['picture'],
                    ),
                    radius: 25.0,
                  ),
                  trailing: FlatButton(
                    onPressed: () {},
                    child: Text('Takipten çık'),
                    color: Colors.white,
                  ),
                  title: Text(followeds[index]['username']),
                  subtitle: Text(followeds[index]['firstname'] +
                      " " +
                      followeds[index]['lastname']),
                );
              },
            ),
    );
  }
}
