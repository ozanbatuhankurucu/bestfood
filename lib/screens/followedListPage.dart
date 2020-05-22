import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:thebestfoodsql/components/functions.dart';
import 'package:thebestfoodsql/screens/userProfilePage.dart';
import 'package:thebestfoodsql/utils/userData.dart';

class FollowedLPage extends StatefulWidget {
  final token;
  FollowedLPage({this.token});
  @override
  _FollowedLPageState createState() => _FollowedLPageState();
}

class _FollowedLPageState extends State<FollowedLPage> {
  Functions functions = new Functions();
  bool circularProgressControl = false;
  ScrollController _scrollController = ScrollController();
  int paginationCount = 0;
  var followeds;

  void getFolloweds() async {
    final response = await UserData.getFollowingMe(widget.token);
    setState(() {
      followeds = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getFolloweds();
    _scrollController.addListener(bringNewFollowings);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void bringNewFollowings() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        circularProgressControl = true;
      });
      paginationCount++;
      print(paginationCount);
      final response =
          await UserData.getFollowingMePage(widget.token, paginationCount);
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
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: followeds == null
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
                          onPressed: () {
                            functions.alertRemoveFollow(context, () async {
                              final response =
                                  await UserData.getRemoveFollowing(
                                      widget.token, followeds[index]['id']);
                              Navigator.pop(context);
                              getFolloweds();
                              print(response);
                            },);
                          },
                          child: Text('Takibi Bırak'),
                          color: Colors.white,
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
