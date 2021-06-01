class MessageSettings {
    String stepName;
    String faceNotFoundMessage;
    String faceTooFarMessage;
    String faceTooCloseMessage;
    String faceNotFittedMessage;
    String multipleFaceDetectedMessage;
    String verifyingLivenessMessage;
    String holdItMessage;
    String invalidFaceMessage;

  MessageSettings(
      {this.stepName, this.faceNotFoundMessage, this.faceTooFarMessage, this.faceTooCloseMessage, this.faceNotFittedMessage, this.multipleFaceDetectedMessage, this.verifyingLivenessMessage, this.holdItMessage, this.invalidFaceMessage});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["stepName"] = stepName;
    map["faceNotFoundMessage"] = faceNotFoundMessage;
    map["faceTooFarMessage"] = faceTooFarMessage;
    map["faceTooCloseMessage"] = faceTooCloseMessage;
    map["faceNotFittedMessage"] = faceNotFittedMessage;
    map["multipleFaceDetectedMessage"] = multipleFaceDetectedMessage;
    map["verifyingLivenessMessage"] = verifyingLivenessMessage;
    map["holdItMessage"] = holdItMessage;
    map["invalidFaceMessage"] = invalidFaceMessage;

    return map;
  }
}
