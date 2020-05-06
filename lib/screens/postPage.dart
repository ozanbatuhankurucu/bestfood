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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 12.0, right: 8.0),
                  child: GestureDetector(
                    child: Icon(FontAwesomeIcons.inbox),
                    onTap: () {
                      /*   Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessagesBoxPage()),
                      ); */
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 12.0, bottom: 8.0),
                  child: CircleAvatar(
                      radius: 10.0,
                      backgroundColor: Colors.green,
                      child: Text('5',
                          style:
                              TextStyle(color: Colors.white, fontSize: 12.0))),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          ); */
        },
        child: Image.asset('images/fork.png'),
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
