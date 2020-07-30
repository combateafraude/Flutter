part of face_authenticator;

class FaceAuthenticator {
  static Map<String, dynamic> _params = {};

  FaceAuthenticator.builder({@required String mobileToken})
      : assert(mobileToken != null) {
    _params['mobileToken'] = mobileToken;
  }

  /// set the user CPF
  void setCpf(String cpf) {
    _params['cpf'] = cpf;
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

  Future<FaceAuthenticatorResult> build() async {
    final response = await FaceAuthenticatorMessenger._messageChannel.invokeMethod('getDocuments', _params);
    if (response.containsKey('success') && response['success']) {
      return FaceAuthenticatorResult(
          authenticated: response['authenticated'] as bool,
          signedResponse: response['signedResponse'] as String);
    } else if (response.containsKey('success') && !response['success']) {
      if (response.containsKey('cancel')) {
        return FaceAuthenticatorResult(
            sdkFailure: (SDKFailure('Cancelado pelo usuário')));
      }
      switch (response['errorType']) {
        case 'InvalidTokenReason':
          return FaceAuthenticatorResult(
              sdkFailure: InvalidTokenReason(response['errorMessage']));
          break;
        case 'PermissionReason':
          return FaceAuthenticatorResult(
              sdkFailure: PermissionReason(response['errorMessage']));
          break;
        case 'NetworkReason':
          return FaceAuthenticatorResult(
              sdkFailure: NetworkReason(response['errorMessage']));
          break;
        case 'ServerReason':
          return FaceAuthenticatorResult(
              sdkFailure: ServerReason(
                  response['errorMessage'], response['errorCode']));
          break;
        case 'StorageReason':
          return FaceAuthenticatorResult(
              sdkFailure: StorageReason(response['errorMessage']));
          break;
        case 'LibraryReason':
          return FaceAuthenticatorResult(
              sdkFailure: LibraryReason(response['errorMessage']));
          break;
        default:
          return FaceAuthenticatorResult(
              sdkFailure: (SDKFailure(response['errorMessage'])));
      }
    }
  }
}
