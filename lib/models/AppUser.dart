class AppUser {
  String id;
  List<String> likes;
  AppUser(this.id);

  List<String> get userLikes {
    return likes;
  }

  set userLikes(List<String> likes) {
    this.likes = likes;
  }
}
