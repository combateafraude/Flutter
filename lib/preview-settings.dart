class PreviewSettings {
  String? title;
  String? subtitle;
  String? confirmLabel;
  String? retryLabel;
  bool? show;

  PreviewSettings(
      {this.show,
      this.title,
      this.subtitle,
      this.confirmLabel,
      this.retryLabel});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["show"] = show;
    map["title"] = title;
    map["subtitle"] = subtitle;
    map["confirmLabel"] = confirmLabel;
    map["retryLabel"] = retryLabel;
    return map;
  }
}
