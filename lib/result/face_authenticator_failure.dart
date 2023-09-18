import 'face_authenticator_result.dart';

class FaceAuthenticatorFailure extends FaceAuthenticatorResult {
  String signedResponse;
  String errorType;
  String errorMessage;
  int code;

  FaceAuthenticatorFailure(
      {this.signedResponse, this.errorType, this.errorMessage, this.code});
}
