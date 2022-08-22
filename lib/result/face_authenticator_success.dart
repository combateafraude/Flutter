import 'face_authenticator_result.dart';

class FaceAuthenticatorSuccess extends FaceAuthenticatorResult {
  static int LENS_FACING_FRONT = 0;
  static int LENS_FACING_BACK = 1;

  bool authenticated;
  String signedResponse;
  String trackingId;
  int lensFacing;

  FaceAuthenticatorSuccess(this.authenticated, this.signedResponse,
      this.trackingId, this.lensFacing);
}
