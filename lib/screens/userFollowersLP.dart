import 'package:flutter/material.dart';
import 'package:thebestfoodsql/screens/userProfilePage.dart';
import 'package:thebestfoodsql/utils/userData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserFollowersLPage extends StatefulWidget {
  final token;
  final uid;
  UserFollowersLPage({this.token, this.uid});
  @override
  _UserFollowersLPageState createState() => _UserFollowersLPageState();
}

class _UserFollowersLPageState extends State<UserFollowersLPage> {
  bool circularProgressControl = false;
  ScrollController _scrollController = ScrollController();
  int paginationCount = 0;
  var followers;
  var userMe;
  void getFollowers() async {
    final response = await UserData.getFollower(widget.token, widget.uid);
    setState(() {
      followers = response;
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
    getFollowers();
    getMe();
    _scrollController.addListener(bringNewUserFollowers);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  void bringNewUserFollowers() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        circularProgressControl = true;
      });
      paginationCount++;
      print(paginationCount);
      final response = await UserData.getFollowerPage(
          widget.token, widget.uid, paginationCount);
      var cameFollowers = response;
      setState(() {
        circularProgressControl = false;
        for (var user in cameFollowers) {
          followers.add(user);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Takipçiler'),
      ),
      body: followers == null || userMe == null
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
