import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:thebestfoodsql/screens/userProfilePage.dart';
import 'package:thebestfoodsql/utils/userData.dart';

class UserFollowedLPage extends StatefulWidget {
  final token;
  final uid;
  UserFollowedLPage({this.token, this.uid});
  @override
  _UserFollowedLPageState createState() => _UserFollowedLPageState();
}

class _UserFollowedLPageState extends State<UserFollowedLPage> {
  bool circularProgressControl = false;
  ScrollController _scrollController = ScrollController();
  int paginationCount = 0;
  var followeds;
  var userMe;
  void getFolloweds() async {
    final response = await UserData.getFollowing(widget.token, widget.uid);
    setState(() {
      followeds = response;
      print(followeds);
    });
  }

  void getMe() async {
    final response = await UserData.getMe(widget.token);
    setState(() {
      userMe = response;
      print(userMe);
    });
  }

  @override
  void initState() {
    super.initState();
    getMe();
    getFolloweds();
    _scrollController.addListener(bringNewUserFollowings);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void bringNewUserFollowings() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        circularProgressControl = true;
      });
      paginationCount++;
      print(paginationCount);
      final response = await UserData.getFollowingPage(
          widget.token, widget.uid, paginationCount);
      var cameFollowings = response;
      setState(() {
        circularProgressControl = false;
        for (var user in cameFollowings) {
          followeds.add(user);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Takip edilenler'),
      ),
      body: followeds == null || userMe == null
          ? Center(
              child: SpinKitCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: followeds.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          if (followeds[index]['id'] != userMe['user']['id']) {
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
                ),
                circularProgressControl == false
                    ? Container()
                    : SpinKitCircle(
                        color: Colors.blue,
                        size: 50.0,
                      ),
              ],
            ),
    );
  }
}
