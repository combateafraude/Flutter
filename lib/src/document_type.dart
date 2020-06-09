part of document_detector_sdk;

enum DocumentType { CNH, RG }

extension DocumentTypeExtension on DocumentType {
  String get code => const {
        DocumentType.CNH: 'CNH',
        DocumentType.RG: 'RG',
      }[this];

  DocumentType getByCode(String code) =>
      const {'CNH': DocumentType.CNH, 'RG': DocumentType.CNH}[code];
}
