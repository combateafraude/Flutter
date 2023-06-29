import 'face_authenticator_result.dart';

class FaceAuthenticatorSuccess extends FaceAuthenticatorResult {
  bool? isAlive;
  bool? isMatch;
  String? userId;
  String? errorMessage;

  FaceAuthenticatorSuccess(
      {this.isAlive, this.isMatch, this.userId, this.errorMessage});
}
