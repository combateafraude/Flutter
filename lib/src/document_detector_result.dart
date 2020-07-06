part of document_detector_sdk;

class DocumentDetectorResult extends SDKResult {
  final String type;
  final Capture captureFront;
  final Capture captureBack;
  final SDKFailure sdkFailure;

  DocumentDetectorResult(
      {this.type, this.sdkFailure, this.captureFront, this.captureBack})
      : super(sdkFailure);

  bool get wasSuccessful => this.sdkFailure == null;

  @override
  String toString() {
    return ('$type, $captureFront, $captureBack, $sdkFailure');
  }
}

class Capture {
  String imagePath;
  String imageUrl;
  int missedAttemps;

  Capture(
      {@required this.imagePath,
      @required this.missedAttemps,
      this.imageUrl = ''});

  @override
  String toString() {
    return ('$imagePath, $missedAttemps, $imageUrl');
  }
}
