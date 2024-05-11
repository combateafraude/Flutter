
class DetectionSettings {
  double threshold;
  int consecutiveFrames;

  DetectionSettings(this.threshold, this.consecutiveFrames);

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["threshold"] = threshold;
    map["consecutiveFrames"] = consecutiveFrames;

    return map;
  }
}