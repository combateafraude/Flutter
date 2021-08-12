class MessageSettings {
  String? fitTheDocumentMessageResIdName;
  String? holdItMessageResIdName;
  String? verifyingQualityMessageResIdName;
  String? lowQualityDocumentMessageResIdName;
  String? uploadingImageMessageResIdName;

  MessageSettings(
      {this.fitTheDocumentMessageResIdName,
      this.holdItMessageResIdName,
      this.verifyingQualityMessageResIdName,
      this.lowQualityDocumentMessageResIdName,
      this.uploadingImageMessageResIdName});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["fitTheDocumentMessageResIdName"] = fitTheDocumentMessageResIdName;
    map["holdItMessageResIdName"] = holdItMessageResIdName;
    map["verifyingQualityMessageResIdName"] = verifyingQualityMessageResIdName;
    map["lowQualityDocumentMessageResIdName"] =
        lowQualityDocumentMessageResIdName;
    map["uploadingImageMessageResIdName"] = uploadingImageMessageResIdName;

    return map;
  }
}
