part of passiveface_liveness_sdk;

class PassiveFaceLivenessResult extends SDKResult {
  final String imagePath;
  final String imageUrl;
  final String signedResponse;
  final int missedAttemps;
  final SDKFailure sdkFailure;

  PassiveFaceLivenessResult(
      {this.sdkFailure,
      this.imagePath,
      this.imageUrl,
      this.signedResponse,
      this.missedAttemps})
      : super(sdkFailure);

  bool get wasSuccessful => this.sdkFailure == null;

  @override
  String toString() {
    return ('$imagePath, $missedAttemps, $imageUrl, $signedResponse, $sdkFailure');
  }
}
