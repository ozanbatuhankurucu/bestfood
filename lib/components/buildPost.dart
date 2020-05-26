import 'package:flutter/material.dart';
import 'package:thebestfoodsql/models/post_model.dart';
import 'package:thebestfoodsql/screens/viewPostDetailPage.dart';

class BuildPost extends StatefulWidget {
  final int index;
  BuildPost({this.index});
  @override
  _BuildPostState createState() => _BuildPostState();
}

class _BuildPostState extends State<BuildPost> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          child: ClipOval(
                            child: Image(
                              height: 50.0,
                              width: 50.0,
                              image: AssetImage(
                                  posts[widget.index].authorImageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        posts[widget.index].authorName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(posts[widget.index].timeAgo),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * (1 / 2),
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        posts[widget.index].imageUrl,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.favorite_border),
                                    iconSize: 30.0,
                                    onPressed: () => print('Like post'),
                                  ),
                                  Text(
                                    '2,515',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20.0),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.chat),
                                    iconSize: 30.0,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ViewPostScreen(
                                            post: posts[widget.index],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    '350',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
