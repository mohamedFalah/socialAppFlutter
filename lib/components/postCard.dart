import 'package:flutter/material.dart';
import 'package:hello_flutter/models/AppUser.dart';
import 'package:hello_flutter/models/Post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hello_flutter/services/firebase_services.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final AppUser user;
  @override
  PostCard({Key key, @required this.post, @required this.user})
      : super(key: key);
  @override
  _PostCard createState() => _PostCard();
}

class _PostCard extends State<PostCard> {
  bool liked = false;
  int numberOfLikes = 0;
  FirebaseServices firebaseServices = FirebaseServices();

  @override
  void initState() {
    super.initState();
  }

  void likeAPost() {
    setState(() {
      if (widget.user.likes.contains(widget.post.id)) {
        widget.post.likes -= 1;
        widget.user.likes.remove(widget.post.id);
        firebaseServices.postLike(false, widget.post.id);
        firebaseServices.updatePostLikes(widget.post.likes, widget.post.id);
      } else {
        widget.post.likes += 1;
        widget.user.likes.add(widget.post.id);
        firebaseServices.postLike(true, widget.post.id);
        firebaseServices.updatePostLikes(widget.post.likes, widget.post.id);
      }
    });
  }

  final likedIcon = new Icon(
    Icons.favorite_rounded,
    color: Colors.red[600],
    size: 38,
  );
  final notLikedIcon = new Icon(
    Icons.favorite_border_rounded,
    size: 38,
  );
  //header
  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Container(
                padding: EdgeInsets.only(left: 5),
                child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black54,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage('images/me.jpg'),
                    )))),
        Container(
          child: Text('Username'),
        ),
        Container(
            alignment: Alignment.center,
            child: IconButton(
              icon: widget.user.userLikes != null
                  ? widget.user.userLikes.contains(widget.post.id)
                      ? likedIcon
                      : notLikedIcon
                  : notLikedIcon,
              onPressed: () {
                likeAPost();
              },
            ))
      ],
    );
  }

  //image
  Widget postImage() {
    return Container(
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 2, right: 2),
          child: CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  //footer
  Widget footer() {
    return Container(
      padding: EdgeInsets.only(top: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              widget.post.caption,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    'Likes',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    widget.post.likes.toString(),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Column(
          children: [header(), postImage(), footer()],
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(72, 76, 82, 0.36),
            offset: Offset(0, 5),
            blurRadius: 16.0,
          ),
        ],
      ),
    );
  }
}
