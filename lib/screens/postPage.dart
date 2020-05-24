import 'package:flutter/material.dart';
import 'package:thebestfoodsql/screens/createPostPage.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          );
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
