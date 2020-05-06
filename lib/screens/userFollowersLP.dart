import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thebestfoodsql/screens/userProfilePage.dart';

//TODO pagination yapilacak
class UserFollowersLPage extends StatefulWidget {
  final token;
  final uid;
  UserFollowersLPage({this.token, this.uid});
  @override
  _UserFollowersLPageState createState() => _UserFollowersLPageState();
}

class _UserFollowersLPageState extends State<UserFollowersLPage> {
  var followers;
  var userMe;
  void getFollowers() async {
    final response = await http.get(
      'http://bestfood.codes2.com/get_follower?id=${widget.uid}',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer ${widget.token}'
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        followers = json.decode(response.body);
      });
      print('takipciler bos geliyor knk');
      print(followers);
    } else {
      throw Exception('Takipçileri çekerken bir hata meydana geldi!');
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
      print(userMe);
    } else {
      throw Exception('Failed to load user info!');
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
                    if (followers[index]['id'] != userMe['user']['id']) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfilePage(
                                  uid: followers[index]['id'],
                                  token: widget.token,
                                )),
                      );
                    }
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      followers[index]['picture'],
                    ),
                    radius: 20.0,
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
