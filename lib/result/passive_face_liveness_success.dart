
import 'package:passive_face_liveness/result/passive_face_liveness_result.dart';

class PassiveFaceLivenessSuccess extends PassiveFaceLivenessResult {

  String imagePath;
  String imageUrl;
  String signedResponse;

  PassiveFaceLivenessSuccess(
      this.imagePath, this.imageUrl, this.signedResponse);
}