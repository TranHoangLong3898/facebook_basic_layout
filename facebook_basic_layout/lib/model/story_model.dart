class Story {
  String img;
  List<dynamic> watched;

  Story(this.img, this.watched);

  static List<Story> toListFromSnapshot(user) {
    List<Story> stories = [];
    if (user['stories'] != null) {
      for (var story in user['stories']) {
        stories.add(Story(story['img'], story['watched']));
      }
    }
    return stories;
  }
}
