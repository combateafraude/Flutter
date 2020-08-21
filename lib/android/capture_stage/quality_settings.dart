
class QualitySettings {
  double threshold;

  QualitySettings(this.threshold);

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["threshold"] = threshold;

    return map;
  }
}