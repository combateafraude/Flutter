
import 'sensor_luminosity_settings.dart';
import 'sensor_orientation_settings.dart';
import 'sensor_stability_settings.dart';

class SensorSettingsIos {
  SensorLuminositySettingsIos sensorLuminosity;
  SensorOrientationSettingsIos sensorOrientation;
  SensorStabilitySettingsIos sensorStability;

  SensorSettingsIos(
      this.sensorLuminosity,
      this.sensorOrientation,
      this.sensorStability);

  Map asMap(){
    Map<String, dynamic> map = new Map();

    map["sensorLuminosity"] = sensorLuminosity?.asMap();
    map["sensorOrientation"] = sensorOrientation?.asMap();
    map["sensorStability"] = sensorStability?.asMap();

    return map;
  }
}
