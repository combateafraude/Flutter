import 'face_authenticator_result.dart';

class FaceAuthenticatorFailure extends FaceAuthenticatorResult {

  String? message;
  String? type;

  FaceAuthenticatorFailure(this.message, this.type);
}