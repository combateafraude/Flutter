class DocumentDetectorCustomizationIos {
  String colorHex;
  String greenMaskImageName;
  String whiteMaskImageName;
  String redMaskImageName;
  String closeImageName;
  bool showStepLabel;
  bool showStatusLabel;
  double buttonSize;
  String buttonContentMode;

  DocumentDetectorCustomizationIos(
      {this.colorHex,
      this.greenMaskImageName,
      this.whiteMaskImageName,
      this.redMaskImageName,
      this.closeImageName,
      this.showStepLabel,
      this.showStatusLabel,
      this.buttonSize,
      this.buttonContentMode});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["colorHex"] = colorHex;
    map["greenMaskImageName"] = greenMaskImageName;
    map["whiteMaskImageName"] = whiteMaskImageName;
    map["redMaskImageName"] = redMaskImageName;
    map["closeImageName"] = closeImageName;
    map["showStepLabel"] = showStepLabel;
    map["showStatusLabel"] = showStatusLabel;
    map["buttonSize"] = buttonSize;
    map["buttonContentMode"] = buttonContentMode;

    return map;
  }
}
