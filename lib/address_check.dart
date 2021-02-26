import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'result/address_check_closed.dart';
import 'result/address_check_result.dart';
import 'result/address_check_success.dart';
import 'result/address_check_failure.dart';
import 'android/address.dart';

class AddressCheck {
  static const MethodChannel _channel = const MethodChannel('address_check');

  String mobileToken;
  String peopleId = "90843623063";
  bool useAnalytics;
  int requestTimeout;
  Address address;

  AddressCheck({@required this.mobileToken});

  void setPeopleId(String peopleId) {
    this.peopleId = peopleId;
  }

  void setAnalyticsSettings(bool useAnalytics) {
    this.useAnalytics = useAnalytics;
  }

  void setNetworkSettings(int requestTimeout) {
    this.requestTimeout = requestTimeout;
  }

  void setAddress(Address address) {
    this.address = address;
  }

  Future<AddressCheckResult> start() async {
    Map<String, dynamic> params = new Map();

    params["mobileToken"] = mobileToken;
    params["peopleId"] = peopleId;
    params["useAnalytics"] = useAnalytics;
    params["requestTimeout"] = requestTimeout;
    params["address"] = this.address?.asMap();

    Map<dynamic, dynamic> resultMap =
        await _channel.invokeMethod('start', params);

    bool success = resultMap["success"];
    return new AddressCheckResult(success);
  }
}
