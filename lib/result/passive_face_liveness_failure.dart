import 'package:passive_face_liveness_nodatabinding/result/passive_face_liveness_result.dart';

class PassiveFaceLivenessFailure extends PassiveFaceLivenessResult {
  String? message;
  String? type;

  PassiveFaceLivenessFailure(this.message, this.type);
}
