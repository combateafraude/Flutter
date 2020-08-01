part of passive_face_liveness;

class SDKResult {
  final SDKFailure sdkFailure;

  SDKResult(this.sdkFailure);
  @override
  String toString() {
    return sdkFailure.toString();
  }
}

class SDKFailure {
  final String message;

  SDKFailure(this.message);

  @override
  String toString() {
    return message;
  }
}

class InvalidTokenReason extends SDKFailure {
  InvalidTokenReason(String message) : super('Token inválido');
}

class PermissionReason extends SDKFailure {
  PermissionReason(String permission)
      : super(
            '$permission é necessária para iniciar o SDK. Por favor, requisite-a ao seu usuário');
}

class NetworkReason extends SDKFailure {
  final String ioExceptionMessage;
  NetworkReason(this.ioExceptionMessage)
      : super('Falha ao conectar-se ao servidor');
}

class ServerReason extends SDKFailure {
  final int code;
  ServerReason(String message, this.code) : super(message);
}

class StorageReason extends SDKFailure {
  final String exceptionMessage;
  StorageReason(this.exceptionMessage)
      : super('Erro no armazenamento do dispositivo');
}

class LibraryReason extends SDKFailure {
  LibraryReason(String libraryMessage) : super(libraryMessage);
}
