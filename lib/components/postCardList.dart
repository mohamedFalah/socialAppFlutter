import 'package:flutter/material.dart';
import 'package:hello_flutter/components/postCard.dart';
import 'package:hello_flutter/models/AppUser.dart';
import 'package:hello_flutter/models/Post.dart';

class PostCardList extends StatefulWidget {
  final List<Post> postList;
  final AppUser user;
  const PostCardList({Key key, this.postList, this.user}) : super(key: key);
  @override
  _PostCardList createState() => _PostCardList();
}

class _PostCardList extends State<PostCardList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.postList.length,
        itemBuilder: (_, index) {
          return Container(
            padding: EdgeInsets.only(bottom: 15),
            child: PostCard(post: widget.postList[index], user: widget.user),
          );
        },
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      ),
    );
  }
}
