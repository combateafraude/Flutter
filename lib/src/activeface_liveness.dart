part of activeface_liveness_sdk;

class ActivefaceLiveness {
  static Map<String, dynamic> _params = {};

  ActivefaceLiveness.builder({@required String mobileToken})
      : assert(mobileToken != null) {
    _params['mobileToken'] = mobileToken;
  }

  /// set how many steps do you want to your client do
  void setNumberOfSteps(int numberOfSteps) {
    _params['numberOfSteps'] = numberOfSteps;
  }

  /// set timeout your client has to act each step
  void setActionTimeout(int actionTimeout) {
    _params['actionTimeout'] = actionTimeout;
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

  /// set the SDK color style for iOS
  void setIOSColorTheme(Color color) {
    _params['colorTheme'] = '#${color.value.toRadixString(16)}';
  }

  Future<ActiveFaceLivenessResult> build() async {
    final response = await ActivefaceLivenessSdk._messageChannel
        .invokeMethod('getDocuments', _params);
    if (response.containsKey('success') && response['success']) {
      return ActiveFaceLivenessResult(
          imagePath: response['imagePath'] as String,
          missedAttemps: response['missedAttemps'] as int);
    } else if (response.containsKey('success') && !response['success']) {
      if (response.containsKey('cancel')) {
        return ActiveFaceLivenessResult(
            sdkFailure: (SDKFailure('Cancelado pelo usuário')));
      }
      switch (response['errorType']) {
        case 'InvalidTokenReason':
          return ActiveFaceLivenessResult(
              sdkFailure: InvalidTokenReason(response['errorMessage']));
          break;
        case 'PermissionReason':
          return ActiveFaceLivenessResult(
              sdkFailure: PermissionReason(response['errorMessage']));
          break;
        case 'NetworkReason':
          return ActiveFaceLivenessResult(
              sdkFailure: NetworkReason(response['errorMessage']));
          break;
        case 'ServerReason':
          return ActiveFaceLivenessResult(
              sdkFailure: ServerReason(
                  response['errorMessage'], response['errorCode']));
          break;
        case 'StorageReason':
          return ActiveFaceLivenessResult(
              sdkFailure: StorageReason(response['errorMessage']));
          break;
        case 'LibraryReason':
          return ActiveFaceLivenessResult(
              sdkFailure: LibraryReason(response['errorMessage']));
          break;
        default:
          return ActiveFaceLivenessResult(
              sdkFailure: (SDKFailure(response['errorMessage'])));
      }
    }
  }
}
