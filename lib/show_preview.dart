class ShowPreview {
  String? titleResIdName;
  String? subTitleResIdName;
  String? confirmLabelResIdName;
  String? retryLabelResIdName;
  bool? show;

  ShowPreview(
      {this.show,
      this.titleResIdName,
      this.subTitleResIdName,
      this.confirmLabelResIdName,
      this.retryLabelResIdName});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["titleResIdName"] = titleResIdName;
    map["subTitleResIdName"] = subTitleResIdName;
    map["confirmLabelResIdName"] = confirmLabelResIdName;
    map["retryLabelResIdName"] = retryLabelResIdName;
    map["show"] = show;
    return map;
  }
}
