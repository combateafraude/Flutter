part of document_detector_sdk;

class DocumentDetectorResult extends SDKResult {
  final String type;
  final List<Capture> capture;

  ///Valid only RG_FLOW or CNH_FLOW
  Capture get captureFront {
    if (capture != null && capture.length == 2) {
      return capture[0];
    } else {
      return null;
    }
  }

  ///Valid only RG_FLOW or CNH_FLOW
  Capture get captureBack {
    if (capture != null && capture.length == 2) {
      return capture[1];
    } else {
      return null;
    }
  }

  final SDKFailure sdkFailure;

  DocumentDetectorResult({this.type, this.sdkFailure, this.capture})
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
  String scannedLabel;
  int missedAttemps;

  Capture(
      {@required this.imagePath,
      @required this.missedAttemps,
      @required this.scannedLabel,
      this.imageUrl = ''});

  @override
  String toString() {
    return ('$imagePath, $missedAttemps, $scannedLabel, $imageUrl');
  }
}
