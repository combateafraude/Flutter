import 'face_authenticator_result.dart';

class FaceAuthenticatorSuccess extends FaceAuthenticatorResult {
  String? signedResponse;
  String? userId;
  String? errorMessage; //perguntar sobre
  bool? isAlive;
  bool? isMatch;

  FaceAuthenticatorSuccess(
      {this.signedResponse,
      this.userId,
      this.errorMessage,
      this.isAlive,
      this.isMatch});
}
