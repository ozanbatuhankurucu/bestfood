import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:thebestfoodsql/screens/userProfilePage.dart';

//TODO pagination yapilacak
class FollowersLPage extends StatefulWidget {
  final token;
  FollowersLPage({this.token});
  @override
  _FollowersLPageState createState() => _FollowersLPageState();
}

class _FollowersLPageState extends State<FollowersLPage> {
  var followers;
  void getFollowers() async {
    final response = await http.get(
      'http://bestfood.codes2.com/get_follower',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        followers = json.decode(response.body);
      });
      print(followers);
    } else {
      throw Exception('Takipçileri çekerken bir hata meydana geldi!');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Takipçiler'),
      ),
      body: followers == null
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                                uid: followers[index]['id'],
                                token: widget.token,
                              )),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      followers[index]['picture'],
                    ),
                    radius: 20.0,
                  ),
                  trailing: FlatButton(
                    onPressed: () {},
                    child: Text('Çıkar'),
                    color: Colors.white,
                  ),
                  title: Text(
                    followers[index]['username'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(followers[index]['firstname'] +
                      " " +
                      followers[index]['lastname']),
                );
              },
              itemCount: followers.length,
            ),
    );
  }
}
