import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:thebestfoodsql/components/functions.dart';
import 'package:thebestfoodsql/screens/userFollowedLP.dart';
import 'package:thebestfoodsql/screens/userFollowersLP.dart';
import 'package:thebestfoodsql/utils/userData.dart';

class UserProfilePage extends StatefulWidget {
  final uid;
  final token;

  UserProfilePage({this.uid, this.token});
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Functions functions = new Functions();
  var user;
  @override
  void initState() {
    super.initState();
    getUserProfileInfo();
  }

  getUserProfileInfo() async {
    final response = await UserData.getProfile(widget.token, widget.uid);
    setState(() {
      user = response;
      print(user);
    });
  }

  Widget userRelationshipFollower(var relationship) {
    Widget button;
    if (relationship == null) {
      button = Text('Takipçi');
    } else {
      if (relationship['state'] == true) {
        button = GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserFollowersLPage(
                        token: widget.token, uid: user['user']['id'])),
              );
            },
            child: Text('Takipçi'));
      } else {
        button = Text('Takipçi');
      }
    }
    return button;
  }

  Widget userRelationshipFollowed(var relationship) {
    Widget button;
    if (relationship == null) {
      button = Text('Takip edilen');
    } else {
      if (relationship['state'] == true) {
        button = GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserFollowedLPage(
                        token: widget.token, uid: user['user']['id'])),
              );
            },
            child: Text('Takip edilen'));
      } else {
        button = Text('Takip edilen');
      }
    }
    return button;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: user == null ? Container() : Text(user['user']['username']),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
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
                            getCurrentButton(user['relationship'], widget.token,
                                widget.uid, context),
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
                                      userRelationshipFollower(
                                          user['relationship']),
                                      userRelationshipFollowed(
                                          user['relationship']),
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

  Widget getCurrentButton(var relationship, var token, var uid, context) {
    Widget button;
    if (relationship == null) {
      button = getButton('Takip et', () async {
        final response = await UserData.getAddFollow(token, uid);
        getUserProfileInfo();
        print(response);
      });
      print(relationship);
    } else {
      if (relationship['state'] == true) {
        print(relationship);
        button = getButton('Takip ediliyor', () {
          functions.alertRemoveFollowing(context, () async {
            final responseInfo = await UserData.getRemoveFollowing(token, uid);
            Navigator.pop(context);
            getUserProfileInfo();
            print(responseInfo);
          });
        });
      } else {
        print(relationship);
        button = getButton('İstek gönderildi', () {});
      }
    }
    return button;
  }

  Widget getButton(String buttonText, Function function) {
    return FlatButton(
        color: Colors.red,
        onPressed: function,
        child: Text(
          buttonText,
          style: TextStyle(color: Colors.white),
        ),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)));
  }
}
