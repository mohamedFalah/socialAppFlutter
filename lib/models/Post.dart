import 'dart:core';

class Post {
  String id;
  String caption;
  String imageUrl;
  int likes;
  int comments;

  Post(this.caption, this.imageUrl, this.likes, this.comments);

  String get getId {
    return id;
  }

  set setId(String id) {
    this.id = id;
  }

  Post.fromJson(Map<dynamic, dynamic> json)
      : caption = json['caption'],
        imageUrl = json['imageUrl'],
        likes = json['likes'],
        comments = json['comments'];

  Map<dynamic, dynamic> toJson() => {
        'caption': caption,
        'imageUrl': imageUrl,
        'likes': likes,
        'comments': comments
      };
}
