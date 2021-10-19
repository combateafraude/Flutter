class DocumentDetectorCustomizationIos {
  String? storyboardName;
  String? viewControllerIdentifier;
  String? colorHex;
  String? greenMaskImageName;
  String? whiteMaskImageName;
  String? redMaskImageName;
  String? closeImageName;
  bool? showStepLabel;
  bool? showStatusLabel;

  DocumentDetectorCustomizationIos(
  {
    this.storyboardName,
    this.viewControllerIdentifier,
    this.colorHex,
    this.greenMaskImageName,
    this.whiteMaskImageName,
    this.redMaskImageName,
    this.closeImageName,
    this.showStepLabel,
    this.showStatusLabel});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["colorHex"] = colorHex;
    map["greenMaskImageName"] = greenMaskImageName;
    map["whiteMaskImageName"] = whiteMaskImageName;
    map["redMaskImageName"] = redMaskImageName;
    map["closeImageName"] = closeImageName;
    map["showStepLabel"] = showStepLabel;
    map["showStatusLabel"] = showStatusLabel;
    map["storyboardName"] = storyboardName;
    map["viewControllerIdentifier"] = viewControllerIdentifier;

    return map;
  }
}
