class MessageSettings {
  String? fitTheDocumentMessage;
  String? holdItMessage;
  String? verifyingQualityMessage;
  String? lowQualityDocumentMessage;
  String? uploadingImageMessage;
  String? openDocumentWrongMessage;
  bool? showOpenDocumentMessage;

  MessageSettings(
      {this.fitTheDocumentMessage,
      this.holdItMessage,
      this.verifyingQualityMessage,
      this.lowQualityDocumentMessage,
      this.uploadingImageMessage,
      this.openDocumentWrongMessage,
      this.showOpenDocumentMessage});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["fitTheDocumentMessage"] = fitTheDocumentMessage;
    map["holdItMessage"] = holdItMessage;
    map["verifyingQualityMessage"] = verifyingQualityMessage;
    map["lowQualityDocumentMessage"] = lowQualityDocumentMessage;
    map["uploadingImageMessage"] = uploadingImageMessage;
    map["openDocumentWrongMessage"] = openDocumentWrongMessage;
    map["showOpenDocumentMessage"] = showOpenDocumentMessage;

    return map;
  }
}
