class DocumentDetectorStepCustomizationAndroid {
  String stepLabelStringResName;
  String illustrationDrawableResName;
  String audioRawResName;

  DocumentDetectorStepCustomizationAndroid(
      {this.stepLabelStringResName,
      this.illustrationDrawableResName,
      this.audioRawResName});

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["stepLabelStringResName"] = stepLabelStringResName;
    map["illustrationDrawableResName"] = illustrationDrawableResName;
    map["audioRawResName"] = audioRawResName;

    return map;
  }
}
