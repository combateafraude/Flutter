class FaceAuthenticatorCsResult {
  final bool isMatch;
  final bool isAlive;
  final String? responseMessage;
  final String? sessionId;

  FaceAuthenticatorCsResult(
      this.isMatch, this.isAlive, this.responseMessage, this.sessionId);
}
