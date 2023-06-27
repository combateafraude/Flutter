import 'package:passive_face_liveness/result/passive_face_liveness_result.dart';

class PassiveFaceLivenessSuccess extends PassiveFaceLivenessResult {
  String? imageUrl;
  bool? isAlive;
  String? token;

  PassiveFaceLivenessSuccess({
    this.imageUrl,
    this.isAlive,
    this.token
  });
}
