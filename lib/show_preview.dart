class ShowPreview {
  String? title;
  String? subtitle;
  String? confirmLabel;
  String? retryLabel;
  bool? show;

  ShowPreview(
      {this.show,
      this.title,
      this.subtitle,
      this.confirmLabel,
      this.retryLabel});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["title"] = title;
    map["subtitle"] = subtitle;
    map["confirmLabel"] = confirmLabel;
    map["retryLabel"] = retryLabel;
    map["show"] = show;

    return map;
  }
}
