import 'package:flutter/material.dart';
import 'package:thebestfoodsql/screens/loginPage.dart';
import 'package:thebestfoodsql/screens/mainPage.dart';
import 'package:thebestfoodsql/utils/tokenProvider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  bool internetControl;
  void getT() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      print('internet yok');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => InternetConnectionPage()),
          (Route<dynamic> route) => false);
    } else {
      String token = await Token.getToken();
      if (token == null) {
        print(token);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainPage()),
            (Route<dynamic> route) => false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getT();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitCircle(
          color: Colors.blue,
          size: 50.0,
        ),
      ),
    );
  }
}

class InternetConnectionPage extends StatefulWidget {
  @override
  _InternetConnectionPageState createState() => _InternetConnectionPageState();
}

class _InternetConnectionPageState extends State<InternetConnectionPage> {
  bool internetControl = false;
  @override
  Widget build(BuildContext context) {
    return internetControl == false
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Text('The Best Food'),
            ),
            body: RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView(
                  children: <Widget>[
                    Text(
                      'İnternet bağlantısı yok !',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'İnternet bağlantınızı kontrol ediniz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, color: Colors.red),
                    ),
                  ],
                )),
          )
        : PageRouter();
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    _checkInternetConnectivity();
    return null;
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        internetControl = false;
      });
    } else {
      print('burdayım');
      setState(() {
        internetControl = true;
      });
    }
  }
}
