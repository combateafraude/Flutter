part of document_detector_sdk;

class DocumentDetector {
  // ignore: non_constant_identifier_names
  static final CNH_FLOW = [
    DocumentDetectorStep(document: DocumentType.CNH_FRONT),
    DocumentDetectorStep(document: DocumentType.CNH_BACK),
  ];

  // ignore: non_constant_identifier_names
  static final RG_FLOW = [
    DocumentDetectorStep(document: DocumentType.RG_FRONT),
    DocumentDetectorStep(document: DocumentType.RG_BACK)
  ];

  Map<String, dynamic> _params = {};

  DocumentDetector.builder(
      {@required String mobileToken, List<DocumentDetectorStep> flow})
      : assert(mobileToken != null),
        assert(flow != null) {
    _params['mobileToken'] = mobileToken;

    List<Map<String, dynamic>> flowMap = [];
    for (var step in flow) {
      flowMap.add(step.toMap());
    }
    _params['flow'] = flowMap;
  }

  /// replace default SDK Mask
  void setAndroidMask(
      {String drawableGreenName,
      String drawableWhiteName,
      String drawableRedName}) {
    if (drawableGreenName != null) _params['nameGreenMask'] = drawableGreenName;
    if (drawableWhiteName != null) _params['nameWhiteMask'] = drawableWhiteName;
    if (drawableRedName != null) _params['nameRedMask'] = drawableRedName;
  }

  /// replace the SDK layout with yours with the respectively template : https://gist.github.com/kikogassen/62068b6e5bc7988d28594d833b125519
  void setAndroidLayout(String layoutName) {
    _params['nameLayout'] = layoutName;
  }

  /// set the SDK color style for Android
  void setAndroidStyle(String styleName) {
    _params['nameStyle'] = styleName;
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
      List<Capture> captureList = [];
      final capture = response['capture'];
      capture.forEach((c) {
        captureList.add(Capture(
            imagePath: c['imagePath'] as String,
            imageUrl: c['imageUrl'] as String,
            missedAttemps: c['missedAttemps'] as int,
            scannedLabel: c['scannedLabel'] as String));
      });
      return DocumentDetectorResult(
          type: response['capture_type'], capture: captureList);
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
