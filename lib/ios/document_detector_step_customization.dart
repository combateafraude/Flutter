class DocumentDetectorStepCustomizationIos {
  String stepLabel;
  String illustration;
  String audioIosName;

  DocumentDetectorStepCustomizationIos(
      this.stepLabel, this.illustration, this.audioIosName);

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["stepLabel"] = stepLabel;
    map["illustration"] = illustration;
    map["audioIosName"] = audioIosName;

    return map;
  }
}
