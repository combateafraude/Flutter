part of document_detector_sdk;

class DocumentDetectorResult extends SDKResult {
  final Capture captureFront;
  final Capture captureBack;
  final SDKFailure sdkFailure;

  DocumentDetectorResult({this.sdkFailure, this.captureFront, this.captureBack})
      : super(sdkFailure);

  @override
  String toString() {
    return ('$captureFront, $captureBack, $sdkFailure');
  }
}

class Capture {
  String imagePath;
  int missedAttemps;

  Capture({@required this.imagePath, @required this.missedAttemps});

  @override
  String toString() {
    return ('$imagePath, $missedAttemps');
  }
}
