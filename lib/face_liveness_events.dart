abstract class FaceLivenessEvent {
  bool get isFinal;

  factory FaceLivenessEvent.fromMap(Map map) {
    switch (map['event']) {
      case 'connecting':
        return const FaceLivenessEventConnecting();
      case 'connected':
        return const FaceLivenessEventConnected();
      case 'validating':
        return const FaceLivenessEventConnecting();
      case 'validated':
        return const FaceLivenessEventConnected();
      case 'canceled':
        return const FaceLivenessEventClosed();
      case 'success':
        return new FaceLivenessEventSuccess(map['signedResponse']);
      case 'failure':
        return new FaceLivenessEventFailure(
            signedResponse: map["signedResponse"],
            errorType: map["errorType"],
            errorMessage: map["errorMessage"],
            code: map["code"]);
      case 'error':
        return new FaceLivenessEventFailure(
            errorType: map["errorType"],
            errorMessage: map["errorMessage"],
            code: map["code"]);
    }
    throw Exception('Invalid event');
  }
}

/// The SDK is connecting to the server. You should provide an indeterminate progress indicator
/// to let the user know that the connection is taking place.
class FaceLivenessEventConnecting implements FaceLivenessEvent {
  @override
  get isFinal => false;

  const FaceLivenessEventConnecting();
}

/// The SDK has connected, and the iProov user interface will now be displayed. You should hide
/// any progress indication at this point.
class FaceLivenessEventConnected implements FaceLivenessEvent {
  @override
  get isFinal => false;

  const FaceLivenessEventConnected();
}

/// The user canceled iProov, either by pressing the close button at the top right, or sending
/// the app to the background.
class FaceLivenessEventClosed implements FaceLivenessEvent {
  @override
  get isFinal => true;

  const FaceLivenessEventClosed();
}

/// The user was successfully verified/enrolled and the token has been validated.
class FaceLivenessEventSuccess implements FaceLivenessEvent {
  @override
  get isFinal => true;

  /// The JWT containing the information of the execution.
  final String? signedResponse;

  const FaceLivenessEventSuccess(this.signedResponse);
}

/// The user was not successfully verified/enrolled, as their identity could not be verified,
/// or there was another issue with their verification/enrollment.
class FaceLivenessEventFailure implements FaceLivenessEvent {
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

  const FaceLivenessEventFailure(
      {this.signedResponse, this.errorType, this.errorMessage, this.code});
}
