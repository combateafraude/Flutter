import 'package:passive_face_liveness/result/passive_face_liveness_result.dart';

class PassiveFaceLivenessSuccess extends PassiveFaceLivenessResult {
  String? imagePath;
  String? capturePath;
  String? imageUrl;
  String? signedResponse;
  String? trackingId;
  int? lensFacing;

  PassiveFaceLivenessSuccess(
      {this.imagePath,
      this.capturePath,
      this.imageUrl,
      this.signedResponse,
      this.trackingId,
      this.lensFacing});
}
