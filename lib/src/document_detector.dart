part of document_detector_sdk;

class DocumentDetector {
  static Map<String, dynamic> _params = {};

  DocumentDetector.builder(
      {@required String mobileToken, @required DocumentType documentType})
      : assert(mobileToken != null),
        assert(documentType != null) {
    _params['mobileToken'] = mobileToken;
    _params['documentType'] = documentType.code;
  }

  /// replace default SDK Mask
  void setAndroidMask(
      {String drawableGreenName,
      String drawableWhiteName,
      String drawableRedName}) {
    if (drawableGreenName != null) _params['setGreenMask'] = drawableGreenName;
    if (drawableWhiteName != null) _params['setWhiteMask'] = drawableWhiteName;
    if (drawableRedName != null) _params['setRedMask'] = drawableRedName;
  }

  /// replace the SDK layout with yours with the respectively template : https://gist.github.com/kikogassen/62068b6e5bc7988d28594d833b125519
  void setAndroidLayout(String layoutName) {
    _params['setLayout'] = layoutName;
  }

  /// set the SDK color style for Android
  void setAndroidStyle(String styleName) {
    _params['setStyle'] = styleName;
  }

  /// set the SDK color style for iOS
  void setIOSColorTheme(Color color) {
    _params['colorTheme'] = '#${color.value.toRadixString(16)}';
  }

  /// Show/hides the step label
  void setIOSShowStepLabel(bool show) {
    _params['showStepLabel'] = show;
  }

  /// Show/hides the status label
  void setIOSShowStatusLabel(bool show) {
    _params['showStatusLabel'] = show;
  }

  /// Sets some layout options to customize the screen.
  void setIOSSLayout(DocumentDetectorLayout layout) {
    _params['layout'] = layout.toMap();
  }

  /// Enables/disables the sound and sound icon
  void hasSound(bool hasSound) {
    _params['hasSound'] = hasSound;
  }

  /// Sets the server request timeout. The default is 15 seconds
  void setRequestTimeout(int requestTimeout) {
    _params['requestTimeout'] = requestTimeout;
  }

  /// Shows/hides the document popup that helps the client
  void showPopup(bool showPopup) {
    _params['showPopup'] = showPopup;
  }

  /// Enable the uploads of the document images, returning its URLs in DocumentDetectorResult.Capture.ImageUrl
  void uploadImages({@required bool upload, @required int imageQuality}) {
    _params['upload'] = upload;
    _params['imageQuality'] = imageQuality;
  }

  Future<DocumentDetectorResult> build() async {
    final response = await DocumentDetectorSdk._messageChannel
        .invokeMethod('getDocuments', _params);
    if (response.containsKey('success') && response['success']) {
      return DocumentDetectorResult(
          type: response['capture_type'],
          captureFront: Capture(
              imagePath: response['captureFront_imagePath'],
              imageUrl: response['captureFront_imageUrl'],
              missedAttemps: response['captureFront_missedAttemps']),
          captureBack: Capture(
              imagePath: response['captureBack_imagePath'],
              imageUrl: response['captureBack_imageUrl'],
              missedAttemps: response['captureBack_missedAttemps']));
    } else if (response.containsKey('success') && !response['success']) {
      if (response.containsKey('cancel')) {
        return DocumentDetectorResult(
            sdkFailure: (SDKFailure('Cancelado pelo usuário')));
      }
      switch (response['errorType']) {
        case 'InvalidTokenReason':
          return DocumentDetectorResult(
              sdkFailure: InvalidTokenReason(response['errorMessage']));
          break;
        case 'PermissionReason':
          return DocumentDetectorResult(
              sdkFailure: PermissionReason(response['errorMessage']));
          break;
        case 'NetworkReason':
          return DocumentDetectorResult(
              sdkFailure: NetworkReason(response['errorMessage']));
          break;
        case 'ServerReason':
          return DocumentDetectorResult(
              sdkFailure: ServerReason(
                  response['errorMessage'], response['errorCode']));
          break;
        case 'StorageReason':
          return DocumentDetectorResult(
              sdkFailure: StorageReason(response['errorMessage']));
          break;
        case 'LibraryReason':
          return DocumentDetectorResult(
              sdkFailure: LibraryReason(response['errorMessage']));
          break;
        default:
          return DocumentDetectorResult(
              sdkFailure: (SDKFailure(response['errorMessage'])));
      }
    } else {
      return DocumentDetectorResult(
          sdkFailure: (SDKFailure('Cancelado pelo usuário')));
    }
  }
}
