import 'package:passive_face_liveness_nodatabinding/result/passive_face_liveness_result.dart';

class PassiveFaceLivenessSuccess extends PassiveFaceLivenessResult {
  String imagePath;
  String imageUrl;
  String signedResponse;
  String trackingId;

  PassiveFaceLivenessSuccess(
      this.imagePath, this.imageUrl, this.signedResponse, this.trackingId);
}
