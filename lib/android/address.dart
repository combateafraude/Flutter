import 'dart:ui';

class Address {
  String _countryName;
  String _countryCode;
  String _adminArea;
  String _subAdminArea;
  String _locality;
  String _subLocality;
  String _thoroughfare;
  String _subThoroughfare;
  String _postalCode;

  Address({Locale locale});

  void setCountryName(String countryName) {
    _countryName = countryName;
  }

  void setCountryCode(String countryCode) {
    _countryCode = countryCode;
  }

  void setAdminArea(String adminArea) {
    _adminArea = adminArea;
  }

  void setSubAdminArea(String subAdminArea) {
    _subAdminArea = subAdminArea;
  }

  void setLocality(String locality) {
    _locality = locality;
  }

  void setSubLocality(String subLocality) {
    _subLocality = subLocality;
  }

  void setThoroughfare(String thoroughfare) {
    _thoroughfare = thoroughfare;
  }

  void setSubThoroughfare(String subThoroughfare) {
    _subThoroughfare = subThoroughfare;
  }

  void setPostalCode(String postalCode) {
    _postalCode = postalCode;
  }

  String getCountryName() {
    return _countryName;
  }

  String getCountryCode() {
    return _countryCode;
  }

  String getAdminArea() {
    return _adminArea;
  }

  String getSubAdminArea() {
    return _subAdminArea;
  }

  String getLocality() {
    return _locality;
  }

  String getSubLocality() {
    return _subLocality;
  }

  String getThoroughfare() {
    return _thoroughfare;
  }

  String getSubThoroughfare() {
    return _subThoroughfare;
  }

  String getPostalCode() {
    return _postalCode;
  }

  Map asMap() {
    Map<String, dynamic> map = new Map();

    map["countryName"] = _countryName;
    map["countryCode"] = _countryCode;
    map["adminArea"] = _adminArea;
    map["subAdminArea"] = _subAdminArea;
    map["locality"] = _locality;
    map["subLocality"] = _subLocality;
    map["thoroughfare"] = _thoroughfare;
    map["subThoroughfare"] = _subThoroughfare;
    map["postalCode"] = _postalCode;
    return map;
  }
}
