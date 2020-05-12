import 'package:flutter/material.dart';
import 'package:thebestfoodsql/utils/userData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FRequestPage extends StatefulWidget {
  final String token;
  FRequestPage({this.token});
  @override
  _FRequestPageState createState() => _FRequestPageState();
}

class _FRequestPageState extends State<FRequestPage> {
  int paginationCount = 0;
  ScrollController _scrollController = ScrollController();
  bool circularProgressControl = false;
  var fRequests;
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(fRequests[index]['firstname'] +
                                    " " +
                                    fRequests[index]['lastname']),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  fRequests[index]['status'] == null
                                      ? GestureDetector(
                                          onTap: () async {
                                            final responseAccept =
                                                await UserData.getAcceptFollow(
                                                    widget.token,
                                                    fRequests[index]['id']);
                                            final user =
                                                await UserData.getProfile(
                                                    widget.token,
                                                    fRequests[index]['id']);
                                            var yeniMap = user['user'];
                                            yeniMap['status'] = user['status'];
                                            fRequests[index] = yeniMap;
                                            print(user);
                                            print(fRequests[index]);
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
                                        )
                                      : Text('Takip et'),
                                  SizedBox(width: 10.0),
                                  GestureDetector(
                                    onTap: () async {
                                      final response =
                                          await UserData.getRemoveFollow(
                                              widget.token,
                                              fRequests[index]['id']);
                                      getFRequests();
                                      print(response);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        color: Colors.white,
                                        child: Text('Sil')),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
}
