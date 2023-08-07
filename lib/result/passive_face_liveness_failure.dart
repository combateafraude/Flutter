import 'package:new_face_liveness_compatible/result/passive_face_liveness_result.dart';

class PassiveFaceLivenessFailure extends PassiveFaceLivenessResult {
  String errorMessage;

  PassiveFaceLivenessFailure(this.errorMessage);
}
