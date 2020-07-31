part of document_detector_sdk;

enum DocumentType {
  RG_FRONT,
  RG_BACK,
  RG_FULL,
  CNH_FRONT,
  CNH_BACK,
  CNH_FULL,
  OTHERS
}

extension DocumentTypeExtension on DocumentType {
  String get code => const {
        DocumentType.CNH_FRONT: 'CNH_FRONT',
        DocumentType.CNH_BACK: 'CNH_BACK',
        DocumentType.CNH_FULL: 'CNH_FULL',
        DocumentType.RG_FRONT: 'RG_FRONT',
        DocumentType.RG_BACK: 'RG_BACK',
        DocumentType.RG_FULL: 'RG_FULL',
        DocumentType.OTHERS: "OTHERS"
      }[this];

  DocumentType getByCode(String code) => const {
        'CNH_FRONT': DocumentType.CNH_FRONT,
        'CNH_BACK': DocumentType.CNH_BACK,
        'CNH_FULL': DocumentType.CNH_FULL,
        'RG_FRONT': DocumentType.RG_FRONT,
        'RG_BACK': DocumentType.RG_BACK,
        'RG_FULL': DocumentType.RG_FULL,
        "OTHERS": DocumentType.OTHERS
      }[code];
}
