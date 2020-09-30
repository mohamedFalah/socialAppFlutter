import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hello_flutter/models/Post.dart';
import 'package:hello_flutter/models/AppUser.dart';
import 'package:uuid/uuid.dart';

class FirebaseServices {
  // vars
  DatabaseReference _posts =
      FirebaseDatabase.instance.reference().child('posts');
  StorageReference _postsImages =
      FirebaseStorage.instance.ref().child('posts-pics');
  // ignore: cancel_subscriptions
  StreamSubscription<Event> _postSubscription;
  // ignore: unused_field
  DatabaseError _error;
  double progress = 0.0;

  //return current postSubscription
  StreamSubscription get postSubscription {
    return _postSubscription;
  }

  //sign in
  void signIn() async {
    try {
      UserCredential _ = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: "", password: "");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  //get current user
  void currentUser(Function onComplete) {
    final User firebaseUser = FirebaseAuth.instance.currentUser;
    //user = AppUser(firebaseUser.uid);
    onComplete(firebaseUser);
  }

  //user status
  void userAuthStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  //posts retrivings
  StreamSubscription getPosts(Function onComplete, Function onFaliure) {
    _posts.keepSynced(true);
    return _posts.onValue.listen((event) {
      onComplete(event);
    }, onError: (Object o) {
      final DatabaseError error = o;
      _error = error;
      onFaliure(_error);
    });
  }

  //save posts to firebase
  Future<void> createPost(File image, String caption, Function onProgress,
      Function onComplete, Function onFaliure) async {
    var imageUrl;
    await uploadImage(image, (progrees) {
      print(progress);
      onProgress(progress);
    }, (url) {
      imageUrl = url;
    });
    var post = Post(caption, imageUrl.toString(), 0, 0);
    var newPost = _posts.push().set(post.toJson());
    newPost.catchError((Object o) {
      final DatabaseError error = o;
      _error = error;
      onFaliure();
    });
    await newPost.whenComplete(() => onComplete(true));
  }

  //upload image to firebaseStorage
  Future<void> uploadImage(
      File image, Function onProgress, Function onComplete) async {
    var uuid = Uuid().toString();
    var newPostImage = _postsImages.child(uuid);
    StorageUploadTask uploadTask = newPostImage.putFile(image);
    uploadTask.events.listen((event) {
      var transferedBytes = event.snapshot.bytesTransferred.toDouble();
      var totalBytes = event.snapshot.totalByteCount.toDouble();
      progress = transferedBytes / totalBytes;
      onProgress(progress);
    }, onError: (Object o) {
      final DatabaseError error = o;
      _error = error;
    });
    await uploadTask.onComplete;
    var url = await newPostImage.getDownloadURL() as String;
    onComplete(url);
  }

  // user like a post
  void postLike(bool value, String postId) {
    String userId = '';
    currentUser((user) {
      userId = user.uid;
    });
    DatabaseReference userLikes = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(userId)
        .child('likes');
    if (value) {
      userLikes.child(postId).set(true);
    } else {
      userLikes.child(postId).remove();
    }
  }

  //update likes
  void updatePostLikes(int likes, String postId) {
    _posts.child(postId).child('likes').set(likes);
  }

  //return user like
  Future<void> userLikes(Function onComplete) async {
    String userId = '';
    currentUser((user) {
      userId = user.uid;
    });
    DatabaseReference userLikes = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(userId)
        .child('likes');

    var likes = await userLikes.once();

    onComplete(likes);
  }
}
