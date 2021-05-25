class MessageSettings {
  String? fitTheDocumentMessage;
  String? holdItMessage;
  String? verifyingQualityMessage;
  String? lowQualityDocumentMessage;
  String? uploadingImageMessage;

  MessageSettings(
      {this.fitTheDocumentMessage,
      this.holdItMessage,
      this.verifyingQualityMessage,
      this.lowQualityDocumentMessage,
      this.uploadingImageMessage});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["fitTheDocumentMessage"] = fitTheDocumentMessage;
    map["holdItMessage"] = holdItMessage;
    map["verifyingQualityMessage"] = verifyingQualityMessage;
    map["lowQualityDocumentMessage"] = lowQualityDocumentMessage;
    map["uploadingImageMessage"] = uploadingImageMessage;

    return map;
  }
}
