import 'package:flutter/material.dart';
import 'package:thebestfoodsql/components/buildPost.dart';
import 'package:thebestfoodsql/screens/createPostPage.dart';
import 'package:thebestfoodsql/utils/tokenProvider.dart';
import 'package:thebestfoodsql/utils/userData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String token;
  var posts = [];
  @override
  void initState() {
    super.initState();
    //getToken();
  }

  void getToken() async {
    token = await Token.getToken();
    getPostMain(token);
  }

  void getPostMain(var token) async {
    final responsePosts = await UserData.postGetMain(token);
    print(responsePosts);
    setState(() {
      posts = responsePosts;
    });
  }

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
            MaterialPageRoute(
                builder: (context) => CreatePostPage(
                      token: token,
                    )),
          );
        },
        child: Image.asset('assets/images/fork.png'),
        backgroundColor: Colors.red,
      ),
      body: posts == null
          ? SpinKitCircle(
              color: Colors.blue,
              size: 50.0,
            )
          : ListView(
              children: <Widget>[
                BuildPost(
                  index: 0,
                ),
                BuildPost(index: 1)
              ],
            ),
    );
  }

  //refreshIndictor
  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));
    getPostMain(token);
    return null;
  }
}
