import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:thebestfoodsql/screens/userProfilePage.dart';
import 'package:thebestfoodsql/utils/tokenProvider.dart';
import 'package:thebestfoodsql/utils/userData.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool circularProgressControl = false;
  ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  int paginationCount = 0;
  String value;
  String token;
  var searchedUsers;
  String errorMessage;
  Future<void> getSearchedUsers() async {
    final response = await UserData.getSearchValue(value, token);
    print(response);
    setState(() {
      errorMessage = null;
      searchedUsers = response;
      if (searchedUsers.length == 0) {
        errorMessage = 'Böyle bir kullanıcı sistemde bulunmamaktadır';
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    _scrollController.addListener(bringNewUsers);
  }
@override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
  void bringNewUsers() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        circularProgressControl = true;
      });
      paginationCount++;
      print(paginationCount);
      final response =
          await UserData.getSearchValuePage(value, token, paginationCount);
      var cameUsers = response;
      setState(() {
        circularProgressControl = false;
        for (var user in cameUsers) {
          searchedUsers.add(user);
        }
      });
    }
  }

  

  void getToken() async {
    token = await Token.getToken();
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              onChanged: (val) {
                value = val;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Bir kullanıcı adı giriniz..';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: 'Kullanıcı adı giriniz',
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(0.0),
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      getSearchedUsers();
                      setState(() {
                        paginationCount = 0;
                      });
                    }
                  },
                ),
              ),
            ),
            errorMessage == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
            searchedUsers == null
                ? Container()
                : Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: searchedUsers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfilePage(
                                        token: token,
                                        uid: searchedUsers[index]['id'],
                                      )),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                searchedUsers[index]['picture'].toString()),
                            radius: 25.0,
                          ),
                          title: Text(
                            searchedUsers[index]['username'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(searchedUsers[index]['firstname'] +
                              " " +
                              searchedUsers[index]['lastname']),
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
      ),
    );
  }
}
