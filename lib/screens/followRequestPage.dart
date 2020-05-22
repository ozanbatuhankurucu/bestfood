import 'package:flutter/material.dart';
import 'package:thebestfoodsql/components/functions.dart';
import 'package:thebestfoodsql/screens/userProfilePage.dart';
import 'package:thebestfoodsql/utils/userData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FRequestPage extends StatefulWidget {
  final String token;
  FRequestPage({this.token});
  @override
  _FRequestPageState createState() => _FRequestPageState();
}

class _FRequestPageState extends State<FRequestPage> {
  Functions functions = new Functions();
  int paginationCount = 0;
  ScrollController _scrollController = ScrollController();
  bool circularProgressControl = false;
  List fRequests;
  @override
  void initState() {
    super.initState();
    getFRequests();
    _scrollController.addListener(bringNewRequests);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void bringNewRequests() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        circularProgressControl = true;
      });
      paginationCount++;
      print(paginationCount);
      final response = await UserData.getFollowRequestListPage(
          widget.token, paginationCount);
      var cameRequests = response;
      setState(() {
        circularProgressControl = false;
        for (var request in cameRequests) {
          fRequests.add(request);
        }
      });
    }
  }

  void getFRequests() async {
    final response = await UserData.getFollowRequestList(widget.token);
    setState(() {
      fRequests = response;
      print(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Takip istekleri',
          style: TextStyle(fontSize: 16.0),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      body: fRequests == null
          ? SpinKitCircle(
              color: Colors.blue,
              size: 50.0,
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: fRequests.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: GestureDetector(
                          onTap: () async {
                            bool result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfilePage(
                                        token: widget.token,
                                        uid: fRequests[index]['id'],
                                      )),
                            );
                            if (result) {
                              getFRequests();
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  fRequests[index]['picture'],
                                ),
                                radius: 25.0,
                              ),
                              SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    fRequests[index]['username'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(fRequests[index]['firstname'] +
                                      " " +
                                      fRequests[index]['lastname']),
                                ],
                              ),
                              fRequests[index]['status'] == null
                                  ? Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () async {
                                              final responseAccept =
                                                  await UserData
                                                      .getAcceptFollow(
                                                          widget.token,
                                                          fRequests[index]
                                                              ['id']);
                                              final user =
                                                  await UserData.getProfile(
                                                      widget.token,
                                                      fRequests[index]['id']);
                                              var yeniMap = user['user'];
                                              yeniMap['status'] =
                                                  user['status'];
                                              yeniMap['relationship'] =
                                                  user['relationship'];
                                              fRequests[index] = yeniMap;
                                              setState(() {});
                                              print(responseAccept);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              color: Colors.red,
                                              child: Text('Onayla',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          GestureDetector(
                                            onTap: () async {
                                              final response = await UserData
                                                  .getRemoveFollow(widget.token,
                                                      fRequests[index]['id']);
                                              if (response['status'] == "Ok") {
                                                setState(() {
                                                  fRequests.removeAt(index);
                                                });
                                              }
                                              print(fRequests);
                                              print(response);
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                color: Colors.white,
                                                child: Text('Sil')),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          getCurrentButton(
                                              fRequests[index]['relationship'],
                                              widget.token,
                                              fRequests[index]['id'],
                                              context,
                                              index),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
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

  Widget getCurrentButton(
      var relationship, var token, var uid, context, int index) {
    Widget button;
    if (relationship == null) {
      button = getButton('Takip et', () async {
        final response = await UserData.getAddFollow(token, uid);
        print(response);
        if (response['status'] == "Ok") {
          fRequests[index]['relationship'] = {'state': false};
          setState(() {});
        }
      });
      print(relationship);
    } else {
      if (relationship['state'] == true) {
        print(relationship);
        button = getButton('Takip ediliyor', () {
          functions.alertRemoveFollow(context, () async {
            //TODOburada yukarıdaki gibi status kontrolü yapılacak şuan api calismadigi için dümenden yaptm
            final response = await UserData.getRemoveFollowing(token, uid);
            Navigator.pop(context);
            fRequests[index]['relationship'] = null;
            print(response);
            setState(() {});
          });
        });
      } else {
        print(relationship);
        button = Container(
          padding: EdgeInsets.all(8.0),
          child:
              Text('İstek gönderildi', style: TextStyle(color: Colors.white)),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30.0),
          ),
        );
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
