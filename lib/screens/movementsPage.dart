import 'package:flutter/material.dart';
import 'package:thebestfoodsql/screens/followRequestPage.dart';
import 'package:thebestfoodsql/utils/tokenProvider.dart';
import 'package:thebestfoodsql/utils/userData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MovementsPage extends StatefulWidget {
  @override
  _MovementsPageState createState() => _MovementsPageState();
}

class _MovementsPageState extends State<MovementsPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Material(
              color: Colors.white,
              child: Center(
                child: TabBar(
                    controller: tabController,
                    indicatorColor: Colors.red,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 4.0,
                    isScrollable: true,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black,
                    tabs: <Widget>[
                      Tab(
                        child: Text(
                          'Takip hareketleri',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Beğeniler',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                FollowMovements(),
                Text('Beğeniler'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FollowMovements extends StatefulWidget {
  @override
  _FollowMovementsState createState() => _FollowMovementsState();
}

class _FollowMovementsState extends State<FollowMovements> {
  String token;
  var requestCount;
  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    token = await Token.getToken();
    getRequestCount(token);
    print(token);
  }

  void getRequestCount(var token) async {
    final response = await UserData.getFollowRequestCount(token);
    print(response);
    setState(() {
      requestCount = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        requestCount == null
            ? SpinKitCircle(
                color: Colors.blue,
                size: 50.0,
              )
            : (requestCount['request_count'] == 0
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                    child: GestureDetector(
                      onTap: () async {
                        bool result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FRequestPage(
                                    token: token,
                                  )),
                        );
                        if (result) {
                          getToken();
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 20.0,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 28.0,
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Text(
                                      requestCount['request_count']
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    radius: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Takip istekleri',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('İstekleri onayla ve ya yoksay'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
      ],
    );
  }

  
}
