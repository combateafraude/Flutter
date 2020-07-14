part of document_detector_sdk;

class DocumentDetectorStep {
  final DocumentType document;
  final String androidStepLabelName;
  final String iosStepLabel;
  final String androidIllustrationName;
  final String iosIllustrationName;
  final String androidAudioName;
  final String iosAudioName;
  final String androidNotFoundMsgName;
  final String iosNotFoundMessage;

  DocumentDetectorStep(
      {@required this.document,
      this.androidStepLabelName,
      this.iosStepLabel,
      this.androidIllustrationName,
      this.iosIllustrationName,
      this.androidAudioName,
      this.iosAudioName,
      this.androidNotFoundMsgName,
      this.iosNotFoundMessage});

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
    if (androidNotFoundMsgName != null) {
      ret['androidNotFoundMsgName'] = androidNotFoundMsgName;
    }
    if (iosNotFoundMessage != null) {
      ret['iosNotFoundMessage'] = iosNotFoundMessage;
    }
    return ret;
  }

  @override
  String toString() {
    return '${document.code}, $androidStepLabelName, $androidIllustrationName, $androidAudioName, $androidNotFoundMsgName';
  }
}
