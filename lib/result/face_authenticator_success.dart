import 'face_authenticator_result.dart';

class FaceAuthenticatorSuccess extends FaceAuthenticatorResult {
  String? signedResponse;

  FaceAuthenticatorSuccess(this.signedResponse);
}
