abstract class FaceAuthenticatorEvent {
  bool get isFinal;

  factory FaceAuthenticatorEvent.fromMap(Map map) {
    switch (map['event']) {
      case 'connecting':
        return const FaceAuthenticatorEventConnecting();
      case 'connected':
        return const FaceAuthenticatorEventConnected();
      case 'validating':
        return const FaceAuthenticatorEventConnecting();
      case 'validated':
        return const FaceAuthenticatorEventConnected();
      case 'canceled':
        return const FaceAuthenticatorEventClosed();
      case 'success':
        return new FaceAuthenticatorEventSuccess(map['signedResponse']);
      case 'failure':
        return new FaceAuthenticatorEventFailure(
            signedResponse: map["signedResponse"],
            errorType: map["errorType"],
            errorMessage: map["errorMessage"],
            code: map["code"]);
      case 'error':
        return new FaceAuthenticatorEventFailure(
            errorType: map["errorType"],
            errorMessage: map["errorMessage"],
            code: map["code"]);
    }
    throw Exception('Invalid event');
  }
}

/// The SDK is connecting to the server. You should provide an indeterminate progress indicator
/// to let the user know that the connection is taking place.
class FaceAuthenticatorEventConnecting implements FaceAuthenticatorEvent {
  @override
  get isFinal => false;

  const FaceAuthenticatorEventConnecting();
}

/// The SDK has connected, and the iProov user interface will now be displayed. You should hide
/// any progress indication at this point.
class FaceAuthenticatorEventConnected implements FaceAuthenticatorEvent {
  @override
  get isFinal => false;

  const FaceAuthenticatorEventConnected();
}

/// The user canceled iProov, either by pressing the close button at the top right, or sending
/// the app to the background.
class FaceAuthenticatorEventClosed implements FaceAuthenticatorEvent {
  @override
  get isFinal => true;

  const FaceAuthenticatorEventClosed();
}

/// The user was successfully verified/enrolled and the token has been validated.
class FaceAuthenticatorEventSuccess implements FaceAuthenticatorEvent {
  @override
  get isFinal => true;

  /// The JWT containing the information of the execution.
  final String? signedResponse;

  const FaceAuthenticatorEventSuccess(this.signedResponse);
}

/// The user was not successfully verified/enrolled, as their identity could not be verified,
/// or there was another issue with their verification/enrollment.
class FaceAuthenticatorEventFailure implements FaceAuthenticatorEvent {
  @override
  get isFinal => true;

  /// The JWT containing the information of the execution.
  final String? signedResponse;

  /// The failure type which can be captured to implement a specific use case for each.
  final String? errorType;

  /// The reason for the failure which can be displayed directly to the user.
  final String? errorMessage;

  /// The feedback code relating to this error. For a list of possible failure codes, see:
  /// * https://github.com/iProov/ios#handling-failures--errors
  /// * https://github.com/iProov/android#handling-failures--errors
  final int? code;

  const FaceAuthenticatorEventFailure(
      {this.signedResponse, this.errorType, this.errorMessage, this.code});
}
