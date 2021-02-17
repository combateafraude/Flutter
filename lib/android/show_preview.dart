class ShowPreview {
  String title;
  String subTitle;
  String acceptLabel;
  String tryAgainLabel;

  ShowPreview(
      {this.title, this.subTitle, this.acceptLabel, this.tryAgainLabel});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["title"] = title;
    map["subTitle"] = subTitle;
    map["acceptLabel"] = acceptLabel;
    map["tryAgainLabel"] = tryAgainLabel;

    return map;
  }
}
