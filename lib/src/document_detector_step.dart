part of document_detector;

class DocumentDetectorStep {
  final DocumentType document;
  final String androidStepLabelName;
  final String iosStepLabel;
  final String androidIllustrationName;
  final String iosIllustrationName;
  final String androidAudioName;
  final String iosAudioName;

  DocumentDetectorStep(
      {@required this.document,
      this.androidStepLabelName,
      this.iosStepLabel,
      this.androidIllustrationName,
      this.iosIllustrationName,
      this.androidAudioName,
      this.iosAudioName});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> ret = Map<String, dynamic>();

    if (document != null) {
      ret['document'] = document.code;
    }
    if (androidStepLabelName != null) {
      ret['androidStepLabelName'] = androidStepLabelName;
    }
    if (iosStepLabel != null) {
      ret['iosStepLabel'] = iosStepLabel;
    }
    if (androidIllustrationName != null) {
      ret['androidIllustrationName'] = androidIllustrationName;
    }
    if (iosIllustrationName != null) {
      ret['iosIllustrationName'] = iosIllustrationName;
    }
    if (androidAudioName != null) {
      ret['androidAudioName'] = androidAudioName;
    }
    if (androidAudioName != null) {
      ret['iosAudioName'] = iosAudioName;
    }
    return ret;
  }

  @override
  String toString() {
    return '${document.code}, $androidStepLabelName, $androidIllustrationName, $androidAudioName';
  }
}
