import 'package:flutter/material.dart';
import 'package:hello_flutter/models/AppUser.dart';
import 'package:hello_flutter/services/firebase_services.dart';
import 'package:hello_flutter/views/feed_screen.dart';
import 'models/Post.dart';

//firebase
import 'package:firebase_core/firebase_core.dart';

// Uncomment lines 7 and 10 to view the visual layout at runtime.
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  List<Post> postList = [];
  AppUser user;

  final firebaseServices = FirebaseServices();
  @override
  void initState() {
    firebaseServices.signIn();
    setState(() {
      getPosts();
      getCurrentUser();
      getUserLikes();
    });

    super.initState();
  }

  void getPosts() {
    firebaseServices.getPosts((event) {
      Map<String, dynamic> posts = Map.from(event.snapshot.value);
      print(posts.keys);
      setState(() {
        postList.clear();
        posts.forEach((key, value) {
          var post = Post.fromJson(value);
          post.setId = key;
          postList.add(post);
        });
      });
      print('reloaded $postList, new list');
    }, (error) {
      print('error $error');
    });
  }

  void getCurrentUser() {
    firebaseServices.currentUser((user) {
      this.user = AppUser(user.uid);
    });
  }

  void getUserLikes() {
    firebaseServices.userLikes((likes) {
      print(likes);
      List<String> likedPostsId = [];
      if (likes.value != null) {
        Map<String, dynamic> data = Map<String, dynamic>.from(likes.value);
        if (data != null) {
          data.forEach((key, value) {
            likedPostsId.add(key);
          });
        }
      }
      print(likedPostsId);
      user.userLikes = likedPostsId;
    });
  }

  @override
  void dispose() {
    firebaseServices.postSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: FeedScreen(postList: postList, user: user),
    );
  }
}
