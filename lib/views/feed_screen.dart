import 'package:flutter/material.dart';
import 'package:hello_flutter/components/bar.dart';
import 'package:hello_flutter/components/postCardList.dart';
import 'package:hello_flutter/components/uplaodCard.dart';
import 'package:hello_flutter/models/AppUser.dart';
import 'package:hello_flutter/models/Post.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({
    Key key,
    @required this.postList,
    @required this.user,
  }) : super(key: key);

  final List<Post> postList;
  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Bar(),
      ),
      body: new Container(
        child: Column(
          children: <Widget>[
            UploadCard(),
            PostCardList(
              postList: postList,
              user: user,
            ),
          ],
        ),
      ),
    );
  }
}
