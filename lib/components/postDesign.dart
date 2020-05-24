import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thebestfoodsql/utils/userData.dart';

class PostDesign extends StatefulWidget {
  final String token;
  final String postID;
  final String postOwnerID;
  final String userName;
  final String venueName;
  final String postImage;
  final String date;
  final String description;
  final Function userPictureClickEvent;
  PostDesign(
      {this.token,
      this.postID,
      this.postOwnerID,
      this.userName,
      this.venueName,
      this.postImage,
      this.date,
      this.description,
      this.userPictureClickEvent});

  @override
  _PostDesignState createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesign> {
  var postOwner;
  @override
  void initState() {
    super.initState();
    getPostOwnerInfo(widget.postOwnerID);
  }

  void getPostOwnerInfo(var ownerID) async {
    final response = await UserData.getUserProfile(widget.token, ownerID);
    setState(() {
      postOwner = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: GestureDetector(
            onTap: widget.userPictureClickEvent,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                "userOwnerImage",
              ),
              radius: 20.0,
            ),
          ),
          title: Text(widget.userName),
          subtitle: Text(widget.venueName),
        ),
        Container(
          height: MediaQuery.of(context).size.height * (1 / 2),
          width: MediaQuery.of(context).size.width,
          child: Image.network(widget.postImage),
        ),
        SizedBox(height: 5.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                          onPressed: () {}, icon: Icon(FontAwesomeIcons.heart)),
                      SizedBox(width: 15.0),
                      IconButton(
                          onPressed: () {
                            /*     Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommentsPage(
                                        currentUid: widget.primaryUserID,
                                        postID: widget.postID,
                                      )),
                            ); */
                          },
                          icon: Icon(FontAwesomeIcons.comment)),
                    ],
                  ),
                  Text(
                    widget.date,
                    style: TextStyle(fontSize: 10.0),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Beğenenler'),
                  GestureDetector(
                      onTap: () {
                        /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WhoLikedPage(
                                    postID: widget.postID,
                                    currentUid: widget.primaryUserID,
                                  )),
                        ); */
                      },
                      child: Text('15 kişi',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              Text(
                'Yemek Önerisi',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                widget.description,
              ),
              SizedBox(height: 5.0),
              GestureDetector(
                onTap: () {
                  /*   Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentsPage(
                                      currentUid: widget.primaryUserID,
                                      postID: widget.postID,
                                    )),
                          ); */
                },
                child: Text('11 yorumun tümünü gör',
                    style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 1.0,
        ),
      ],
    );
  }
}
