import 'face_authenticator_result.dart';

class FaceAuthenticatorSuccess extends FaceAuthenticatorResult {
  String signedResponse;
  String userId;
  String errorMessage;
  bool isAlive;
  bool isMatch;

  FaceAuthenticatorSuccess(
      {this.signedResponse,
      this.userId,
      this.errorMessage,
      this.isAlive,
      this.isMatch});
}
