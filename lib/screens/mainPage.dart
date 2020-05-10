import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thebestfoodsql/screens/movementsPage.dart';
import 'package:thebestfoodsql/screens/postPage.dart';
import 'package:thebestfoodsql/screens/profilePage.dart';
import 'package:thebestfoodsql/screens/searchPage.dart';
import 'package:thebestfoodsql/utils/constants.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    getToken();
  }

  //token gosterme amacli oylesine koyulmus bir metot
  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? null;
    print('read : $value');
  }

  List<Widget> _widgetOptions = <Widget>[
    PostPage(),
    SearchPage(),
    MovementsPage(),
    ProfilePage(),
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: BottomNavigationBar(
          elevation: 8.0,
          unselectedIconTheme: IconThemeData(color: Color(0xFF949494)),
          selectedIconTheme: IconThemeData(color: kPrimaryColor),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.home,
              ),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.search,
              ),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.heartbeat,
              ),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.user,
              ),
              title: Text(""),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
