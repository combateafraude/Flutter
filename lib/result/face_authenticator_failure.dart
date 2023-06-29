import 'face_authenticator_result.dart';

class FaceAuthenticatorFailure extends FaceAuthenticatorResult {
  String? errorMessage;

  FaceAuthenticatorFailure(this.errorMessage);
}
