import 'face_authenticator_cs_platform_interface.dart';
import 'face_authenticator_result.dart';

class FaceAuthenticatorCs {
  late final String _clientId;
  late final String _clientSecret;
  late final String _token;
  late final String _personId;

  FaceAuthenticatorCs(
      String clientId, String clientSecret, String token, String personId) {
    _clientId = clientId;
    _clientSecret = clientSecret;
    _token = token;
    _personId = personId;
  }

  Future<FaceAuthenticatorCsResult> start() async {
    Map<String, dynamic> params = {};

    params["clientId"] = _clientId;
    params["clientSecret"] = _clientSecret;
    params["token"] = _token;
    params["personId"] = _personId;

    Map resultMap = await FaceAuthenticatorCsPlatform.instance.start(params);

    return FaceAuthenticatorCsResult(resultMap["isMatch"], resultMap["isAlive"],
        resultMap["responseMessage"], resultMap["sessionId"]);
  }
}
