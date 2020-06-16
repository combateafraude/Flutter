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
    _params['nameLayout'] = layoutName;
  }

  /// enable/disable the SDK sound
  void hasSound(bool hasSound) {
    _params['hasSound'] = hasSound;
  }

  /// set the SDK color style for Android
  void setAndroidStyle(String styleName) {
    _params['nameStyle'] = styleName;
  }

  /// set the server calls request timeout. The default is 30 seconds
  void setRequestTimeout(int requestTimeout) {
    _params['requestTimeout'] = requestTimeout;
  }

  /// set the SDK color style for iOS
  void setIOSColorTheme(Color color) {
    _params['colorTheme'] = '#${color.value.toRadixString(16)}';
  }

  Future<DocumentDetectorResult> build() async {
    debugPrint("DocumentDetectorSdk - call PlatformChannel");
    final response = await DocumentDetectorSdk._messageChannel
        .invokeMethod('getDocuments', _params);
    debugPrint("DocumentDetectorSdk - return PlatformChannel");
    debugPrint("DocumentDetectorSdk - ${response.toString()}");
    if (response.containsKey('success') && response['success']) {
      return DocumentDetectorResult(
          captureFront: Capture(
              imagePath: response['captureFront_imagePath'],
              missedAttemps: response['captureFront_missedAttemps']),
          captureBack: Capture(
              imagePath: response['captureBack_imagePath'],
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
    }
  }
}
