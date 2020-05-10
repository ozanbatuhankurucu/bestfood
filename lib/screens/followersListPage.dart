import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:thebestfoodsql/screens/userProfilePage.dart';
import 'package:thebestfoodsql/utils/userData.dart';

class FollowersLPage extends StatefulWidget {
  final token;
  FollowersLPage({this.token});
  @override
  _FollowersLPageState createState() => _FollowersLPageState();
}

class _FollowersLPageState extends State<FollowersLPage> {
  bool circularProgressControl = false;
  ScrollController _scrollController = ScrollController();
  int paginationCount = 0;
  var followers;
  void getFollowers() async {
    final response = await UserData.getFollowersMe(widget.token);
    setState(() {
      followers = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getFollowers();
    _scrollController.addListener(bringNewFollowers);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void bringNewFollowers() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        circularProgressControl = true;
      });
      paginationCount++;
      print(paginationCount);
      final response =
          await UserData.getFollowersMePage(widget.token, paginationCount);
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
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: followers == null
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
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
                          onPressed: () async {
                            final response = await UserData.getRemoveFollow(
                                widget.token, followers[index]['id']);
                            print(response);
                            getFollowers();
                          },
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
