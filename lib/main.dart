import 'package:flutter/material.dart';
import 'package:thebestfoodsql/screens/loginPage.dart';
import 'package:thebestfoodsql/screens/mainPage.dart';
import 'package:thebestfoodsql/utils/tokenProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red),
      debugShowCheckedModeBanner: false,
      title: 'The Best Food',
      home: PageRouter(),
    );
  }
}

class PageRouter extends StatefulWidget {
  @override
  _PageRouterState createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  void getT() async {
    String token = await Token.getToken();
    if (token == null) {
      print(token);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    getT();
  }

  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}
