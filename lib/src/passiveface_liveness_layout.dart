part of passiveface_liveness_sdk;

class PassiveFaceLivenessLayout {
  final String closeImageName;
  final String greenMaskImageName;
  final String whiteMaskImageName;
  final String redMaskImageName;
  final String soundOnImageName;
  final String soundOffImageName;

  PassiveFaceLivenessLayout(
      {this.closeImageName,
      this.greenMaskImageName,
      this.whiteMaskImageName,
      this.redMaskImageName,
      this.soundOnImageName,
      this.soundOffImageName});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> ret = Map<String, dynamic>();

    if (greenMaskImageName != null) {
      ret['greenMaskImageName'] = greenMaskImageName;
    }
    if (whiteMaskImageName != null) {
      ret['whiteMaskImageName'] = whiteMaskImageName;
    }
    if (redMaskImageName != null) {
      ret['redMaskImageName'] = redMaskImageName;
    }
    if (soundOnImageName != null) {
      ret['soundOnImageName'] = soundOnImageName;
    }
    if (soundOffImageName != null) {
      ret['soundOffImageName'] = soundOffImageName;
    }
    if (closeImageName != null) {
      ret['closeImageName'] = closeImageName;
    }

    return ret;
  }
}
