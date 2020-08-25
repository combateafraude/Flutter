class PassiveFaceLivenessCustomizationIos {
  String greenMaskImageName;
  String whiteMaskImageName;
  String redMaskImageName;
  String closeImageName;
  bool showStepLabel;
  bool showStatusLabel;

  PassiveFaceLivenessCustomizationIos(
      this.greenMaskImageName,
      this.whiteMaskImageName,
      this.redMaskImageName,
      this.closeImageName,
      this.showStepLabel,
      this.showStatusLabel);

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["greenMaskImageName"] = greenMaskImageName;
    map["whiteMaskImageName"] = whiteMaskImageName;
    map["redMaskImageName"] = redMaskImageName;
    map["closeImageName"] = closeImageName;
    map["showStepLabel"] = showStepLabel;
    map["showStatusLabel"] = showStatusLabel;

    return map;
  }
}
