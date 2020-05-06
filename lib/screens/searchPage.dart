import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:thebestfoodsql/screens/userProfilePage.dart';
import 'package:thebestfoodsql/utils/tokenProvider.dart';

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
  List searchedUsers;
  String errorMessage;
  Future<void> getSearchedUsers() async {
    print(value);
    final response = await http.get(
      'http://bestfood.codes2.com/search?value=$value',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        errorMessage = null;
        searchedUsers = json.decode(response.body);
        if (searchedUsers.length == 0) {
          errorMessage = 'Böyle bir kullanıcı sistemde bulunmamaktadır';
        }
      });

      print(searchedUsers);
    } else {
      print(response.statusCode);
      throw Exception('Aranan kullanıcılar getirilemedi!');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          circularProgressControl = true;
        });
        paginationCount++;
        print(paginationCount);
        final response = await http.get(
          'http://bestfood.codes2.com/search?value=$value&page=$paginationCount',
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token'
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            var cameUsers = json.decode(response.body);
            print(cameUsers.length);
            circularProgressControl = false;

            print(cameUsers);
            for (var user in cameUsers) {
              searchedUsers.add(user);
            }
          });
        } else {
          print(response.statusCode);
          throw Exception('Aranan kullanıcılar getirilemedi!');
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
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
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await getSearchedUsers();
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
