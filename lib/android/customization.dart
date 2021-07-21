class FaceAuthenticatorCustomizationAndroid {
  String? styleResIdName;
  String? layoutResIdName;
  String? greenMaskResIdName;
  String? redMaskResIdName;
  String? whiteMaskResIdName;

  FaceAuthenticatorCustomizationAndroid(
      {this.styleResIdName,
      this.layoutResIdName,
      this.greenMaskResIdName,
      this.redMaskResIdName,
      this.whiteMaskResIdName});

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["styleResIdName"] = styleResIdName;
    map["layoutResIdName"] = layoutResIdName;
    map["greenMaskResIdName"] = greenMaskResIdName;
    map["redMaskResIdName"] = redMaskResIdName;
    map["whiteMaskResIdName"] = whiteMaskResIdName;

    return map;
  }
}
