import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:thebestfoodsql/screens/userProfilePage.dart';

//TODO pagination yapilacak
class UserFollowedLPage extends StatefulWidget {
  final token;
  final uid;
  UserFollowedLPage({this.token, this.uid});
  @override
  _UserFollowedLPageState createState() => _UserFollowedLPageState();
}

class _UserFollowedLPageState extends State<UserFollowedLPage> {
  var followeds;
  var userMe;
  void getFolloweds() async {
    print(widget.uid);
    final response = await http.get(
      'http://bestfood.codes2.com/get_following?id=${widget.uid}',
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

    final responseMe = await http.get(
      'http://bestfood.codes2.com/me',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${widget.token}'
      },
    );
    if (responseMe.statusCode == 200) {
      setState(() {
        userMe = json.decode(responseMe.body);
      });
      
    } else {
      throw Exception('Failed to load user info!');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFolloweds();
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
                    if (followeds[index]['id'] != userMe['id']) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfilePage(
                                  uid: followeds[index]['id'],
                                  token: widget.token,
                                )),
                      );
                    }
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      followeds[index]['picture'],
                    ),
                    radius: 25.0,
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
