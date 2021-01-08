class Globals {
  static final posts = PostBank();
}

// Fake server for posts
class PostBank {
  List<String> posts = [];
  int index = 0;

  initPosts() {
    for (var i = 0; i < 200; i++) {
      posts.add("Post " + i.toString());
    }
  }

  String getNextPost() {
    return posts[index++];
  }

  get hasNextItem => index < posts.length;
}
