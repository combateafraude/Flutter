part of document_detector_sdk;

class ImageResponse {
  final String uploadUrl;
  final String getUrl;

  ImageResponse({@required this.uploadUrl, @required this.getUrl});

  @override
  String toString() {
    return '$uploadUrl, $getUrl';
  }
}
