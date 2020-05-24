import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thebestfoodsql/screens/followedListPage.dart';
import 'package:thebestfoodsql/screens/followersListPage.dart';
import 'package:thebestfoodsql/screens/loginPage.dart';
import 'package:thebestfoodsql/utils/constants.dart';
import 'package:thebestfoodsql/utils/tokenProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:thebestfoodsql/utils/userData.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userInfo;
  String token;
  Future takePhoto(context) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 45);
    uploadPhoto(context, image);
  }

  Future pickCamera(context) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 45);
    uploadPhoto(context, image);
  }

  Future<void> uploadPhoto(BuildContext context, var image) async {
    if (image != null) {
      final response = await UserData.uploadProfileImage(token, image);
      print(response);
      print(response.statusCode);
      Navigator.pop(context);
      getToken();
      print(userInfo['user']['picture']);
      setState(() {
        print("Profil Resmi Yüklendi");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profil resmi yüklendi')));
      });
    }
  }

  void choiceAction(String choice) async {
    if (choice == "signout") {
      try {
        await Token.resetUserToken();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      } catch (e) {
        print(e);
      }
    } else if (choice == "editprofile") {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    print('initstate calisti');
  }

  void getToken() async {
    token = await Token.getToken();
    getMe(token);
  }

  void getMe(String token) async {
    print('getMe calisti');
    final response = await UserData.getMe(token);
    setState(() {
      userInfo = response;
      print(userInfo['user']['picture']);
      print(userInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            new PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    child: Text("Profili düzenle"),
                    value: "editprofile",
                  ),
                  PopupMenuItem<String>(
                    child: Text("Çıkış yap"),
                    value: "signout",
                  ),
                ];
              },
            ),
          ],
          title: userInfo == null
              ? Container()
              : Text(userInfo['user']['username']),
          centerTitle: true,
          automaticallyImplyLeading: false),
      body: userInfo == null
          ? SpinKitCircle(
              color: Colors.blue,
              size: 50.0,
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  kSizedBoxTwenty,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userInfo['user']['picture']),
                                radius: 40.0,
                              ),
                              Positioned(
                                right: 0.0,
                                bottom: 0.0,
                                child: Container(
                                  height: 25.0,
                                  width: 25.0,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      _settingModalBottomSheet(context);
                                    },
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.add,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      kSizedBoxFifty,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('0',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(userInfo['follower_count'].toString(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(userInfo['following_count'].toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Gönderi'),
                              GestureDetector(
                                  onTap: () async {
                                    bool result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FollowersLPage(
                                                token: token,
                                              )),
                                    );
                                    if (result) {
                                      getToken();
                                      print('geri geldim');
                                    }
                                  },
                                  child: Text('Takipçi')),
                              GestureDetector(
                                  onTap: () async {
                                    bool result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FollowedLPage(
                                                token: token,
                                              )),
                                    );
                                    if (result) {
                                      getToken();
                                    }
                                  },
                                  child: Text('Takip edilen'))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(userInfo['user']['firstname'] +
                              " " +
                              userInfo['user']['lastname']),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Fotoğraf çek'),
                    onTap: () {
                      pickCamera(context);
                    }),
                new ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Galeriden seç'),
                  onTap: () {
                    takePhoto(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
