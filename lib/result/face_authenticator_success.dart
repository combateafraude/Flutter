import 'face_authenticator_result.dart';

class FaceAuthenticatorSuccess extends FaceAuthenticatorResult {

  bool authenticated;
  String signedResponse;

  FaceAuthenticatorSuccess(
      this.authenticated, this.signedResponse);
}