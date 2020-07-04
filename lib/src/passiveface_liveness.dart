part of passiveface_liveness_sdk;

class PassiveFaceLiveness {
  static Map<String, dynamic> _params = {};

  PassiveFaceLiveness.builder({@required String mobileToken})
      : assert(mobileToken != null) {
    _params['mobileToken'] = mobileToken;
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

  /// enable/disable the SDK sound
  void hasSound(bool hasSound) {
    _params['hasSound'] = hasSound;
  }

  /// set the SDK color style for Android
  void setAndroidStyle(String styleName) {
    _params['setStyle'] = styleName;
  }

  /// set the server calls request timeout. The default is 30 seconds
  void setRequestTimeout(int requestTimeout) {
    _params['requestTimeout'] = requestTimeout;
  }

  /// Show/hides the step label
  void setShowStepLabel(bool show) {
    _params['showStepLabel'] = show;
  }

  /// Show/hides the status label
  void setShowStatusLabel(bool show) {
    _params['showStatusLabel'] = show;
  }

  Future<PassiveFaceLivenessResult> build() async {
    final response = await PassiveFaceLivenessSdk._messageChannel
        .invokeMethod('getDocuments', _params);
    if (response.containsKey('success') && response['success']) {
      return PassiveFaceLivenessResult(
          imagePath: response['imagePath'] as String ?? '',
          imageUrl: response['imageUrl'] as String ?? '',
          signedResponse: response['signedResponse'] as String ?? '',
          missedAttemps: response['missedAttemps'] as int);
    } else if (response.containsKey('success') && !response['success']) {
      if (response.containsKey('cancel')) {
        return PassiveFaceLivenessResult(
            sdkFailure: (SDKFailure('Cancelado pelo usuário')));
      }
      switch (response['errorType']) {
        case 'InvalidTokenReason':
          return PassiveFaceLivenessResult(
              sdkFailure: InvalidTokenReason(response['errorMessage']));
          break;
        case 'PermissionReason':
          return PassiveFaceLivenessResult(
              sdkFailure: PermissionReason(response['errorMessage']));
          break;
        case 'NetworkReason':
          return PassiveFaceLivenessResult(
              sdkFailure: NetworkReason(response['errorMessage']));
          break;
        case 'ServerReason':
          return PassiveFaceLivenessResult(
              sdkFailure: ServerReason(
                  response['errorMessage'], response['errorCode']));
          break;
        case 'StorageReason':
          return PassiveFaceLivenessResult(
              sdkFailure: StorageReason(response['errorMessage']));
          break;
        case 'LibraryReason':
          return PassiveFaceLivenessResult(
              sdkFailure: LibraryReason(response['errorMessage']));
          break;
        default:
          return PassiveFaceLivenessResult(
              sdkFailure: (SDKFailure(response['errorMessage'])));
      }
    }
  }
}
