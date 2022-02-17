class PassiveFaceLivenessCustomizationAndroid {
  String? styleResIdName;
  String? layoutResIdName;
  String? greenMaskResIdName;
  String? redMaskResIdName;
  String? whiteMaskResIdName;
  String? maskType;

  PassiveFaceLivenessCustomizationAndroid(
      {this.styleResIdName,
      this.layoutResIdName,
      this.greenMaskResIdName,
      this.redMaskResIdName,
      this.whiteMaskResIdName,
      this.maskType});

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["styleResIdName"] = styleResIdName;
    map["layoutResIdName"] = layoutResIdName;
    map["greenMaskResIdName"] = greenMaskResIdName;
    map["redMaskResIdName"] = redMaskResIdName;
    map["whiteMaskResIdName"] = whiteMaskResIdName;
    map["maskType"] = maskType;

    return map;
  }
}
