class PreviewSettings {
  String title;
  String subTitle;
  String confirmLabel;
  String retryLabel;
  bool show;

  PreviewSettings(
      {this.show,
      this.title,
      this.subTitle,
      this.confirmLabel,
      this.retryLabel});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["title"] = title;
    map["subTitle"] = subTitle;
    map["confirmLabel"] = confirmLabel;
    map["retryLabel"] = retryLabel;
    map["show"] = show;

    return map;
  }
}
