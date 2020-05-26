import 'package:flutter/material.dart';
import 'package:thebestfoodsql/models/comment_model.dart';
import 'package:thebestfoodsql/models/post_model.dart';

class ViewPostScreen extends StatefulWidget {
  final Post post;

  ViewPostScreen({this.post});

  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  TextEditingController commentController;
  String comment;
  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    commentController.addListener(listener);
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void listener() {
    setState(() {
      comment = commentController.text;
    });
  }

  Widget _buildComment(int index) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListTile(
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
                image: AssetImage(comments[index].authorImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          comments[index].authorName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(comments[index].text),
        trailing: IconButton(
          icon: Icon(
            Icons.favorite_border,
          ),
          color: Colors.grey,
          onPressed: () => print('Like comment'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDF0F6),
      body: Column(
        children: <Widget>[
          //Buraya o postun descriptioni gelebilir
          Expanded(
            child: ListView(
              children: <Widget>[
                _buildComment(0),
                _buildComment(1),
                _buildComment(2),
                _buildComment(3),
                _buildComment(4),
              ],
            ),
          ),
          TextField(
            autofocus: false,
            controller: commentController,
            decoration: InputDecoration(
                suffix: commentController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback(
                              (_) => commentController.clear());
                        },
                        child: Text('Yorum yap'))
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                )),
          ),
        ],
      ),
    );
  }
}
