import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Map<String, dynamic>> posts = List();
  String uid;

  void getPost() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Best Food'),
        automaticallyImplyLeading: false,
        actions: <Widget>[],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          ); */
        },
        child: Image.asset('images/fork.png'),
        backgroundColor: Colors.red,
      ),
      body: Container(),
    );
  }

  //refreshIndictor
  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));
    getPost();

    return null;
  }
}
