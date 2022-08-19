import 'package:passive_face_liveness/result/passive_face_liveness_result.dart';

class PassiveFaceLivenessSuccess extends PassiveFaceLivenessResult {
  static int LENS_FACING_FRONT = 0;
  static int LENS_FACING_BACK = 1;
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
