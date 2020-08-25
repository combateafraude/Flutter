class DocumentDetectorStepCustomizationIos {
  String stepLabel;
  String illustration;
  String audioName;

  DocumentDetectorStepCustomizationIos(
      this.stepLabel, this.illustration, this.audioName);

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["stepLabel"] = stepLabel;
    map["illustration"] = illustration;
    map["audioName"] = audioName;

    return map;
  }
}
