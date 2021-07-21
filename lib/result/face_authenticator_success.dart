import 'face_authenticator_result.dart';

class FaceAuthenticatorSuccess extends FaceAuthenticatorResult {
  bool authenticated;
  String signedResponse;
  String trackingId;

  FaceAuthenticatorSuccess(
      this.authenticated, this.signedResponse, this.trackingId);
}
