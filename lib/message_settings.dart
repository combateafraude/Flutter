class MessageSettings {
  String? waitMessage;
  String? fitTheDocumentMessage;
  String? holdItMessage;
  String? verifyingQualityMessage;
  String? lowQualityDocumentMessage;
  String? uploadingImageMessage;
  String? openDocumentWrongMessage;
  bool? showOpenDocumentMessage;

  String? unsupportedDocumentMessage;
  String? wrongDocumentMessage_RG_FRONT;
  String? wrongDocumentMessage_RG_BACK;
  String? wrongDocumentMessage_RG_FULL;
  String? wrongDocumentMessage_CNH_FRONT;
  String? wrongDocumentMessage_CNH_BACK;
  String? wrongDocumentMessage_CNH_FULL;
  String? wrongDocumentMessage_CRLV;
  String? wrongDocumentMessage_RNE_FRONT;
  String? wrongDocumentMessage_RNE_BACK;


  MessageSettings(
      {this.waitMessage,  
      this.fitTheDocumentMessage,
      this.holdItMessage,
      this.verifyingQualityMessage,
      this.lowQualityDocumentMessage,
      this.uploadingImageMessage,
      this.openDocumentWrongMessage,
      this.showOpenDocumentMessage,
      this.unsupportedDocumentMessage,
      this.wrongDocumentMessage_RG_FRONT,
      this.wrongDocumentMessage_RG_BACK,
      this.wrongDocumentMessage_RG_FULL,
      this.wrongDocumentMessage_CNH_FRONT,
      this.wrongDocumentMessage_CNH_BACK,
      this.wrongDocumentMessage_CNH_FULL,
      this.wrongDocumentMessage_CRLV,
      this.wrongDocumentMessage_RNE_FRONT,
      this.wrongDocumentMessage_RNE_BACK});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["waitMessage"] = waitMessage;
    map["fitTheDocumentMessage"] = fitTheDocumentMessage;
    map["holdItMessage"] = holdItMessage;
    map["verifyingQualityMessage"] = verifyingQualityMessage;
    map["lowQualityDocumentMessage"] = lowQualityDocumentMessage;
    map["uploadingImageMessage"] = uploadingImageMessage;
    map["openDocumentWrongMessage"] = openDocumentWrongMessage;
    map["showOpenDocumentMessage"] = showOpenDocumentMessage;

    map["unsupportedDocumentMessage"] = unsupportedDocumentMessage;
    map["wrongDocumentMessage_RG_FRONT"] = wrongDocumentMessage_RG_FRONT;
    map["wrongDocumentMessage_RG_BACK"] = wrongDocumentMessage_RG_BACK;
    map["wrongDocumentMessage_RG_FULL"] = wrongDocumentMessage_RG_FULL;
    map["wrongDocumentMessage_CNH_FRONT"] = wrongDocumentMessage_CNH_FRONT;
    map["wrongDocumentMessage_CNH_BACK"] = wrongDocumentMessage_CNH_BACK;
    map["wrongDocumentMessage_CNH_FULL"] = wrongDocumentMessage_CNH_FULL;
    map["wrongDocumentMessage_CRLV"] = wrongDocumentMessage_CRLV;
    map["wrongDocumentMessage_RNE_FRONT"] = wrongDocumentMessage_RNE_FRONT;
    map["wrongDocumentMessage_RNE_BACK"] = wrongDocumentMessage_RNE_BACK;

    return map;
  }
}
