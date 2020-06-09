part of activeface_liveness_sdk;

class ActiveFaceLivenessResult extends SDKResult {
  final String imagePath;
  final int missedAttemps;
  final SDKFailure sdkFailure;

  ActiveFaceLivenessResult(
      {this.sdkFailure, this.imagePath, this.missedAttemps})
      : super(sdkFailure);

  @override
  String toString() {
    return ('$imagePath, $missedAttemps, $sdkFailure');
  }
}
