import 'package:new_face_liveness_compatible/result/passive_face_liveness_result.dart';

class PassiveFaceLivenessFailure extends PassiveFaceLivenessResult {
  String signedResponse;
  String errorType;
  String errorMessage;
  int code;

  PassiveFaceLivenessFailure(
      {this.signedResponse, this.errorType, this.errorMessage, this.code});
}
