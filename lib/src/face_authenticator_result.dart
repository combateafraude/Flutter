part of face_authenticator;

class FaceAuthenticatorResult extends SDKResult {
  final bool authenticated;
  final String signedResponse;
  final SDKFailure sdkFailure;

  FaceAuthenticatorResult(
      {this.sdkFailure, this.authenticated, this.signedResponse})
      : super(sdkFailure);

  @override
  String toString() {
    return ('$authenticated, $signedResponse, $sdkFailure');
  }
}
