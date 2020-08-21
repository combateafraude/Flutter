
class SDKFailure {
  String message;

  SDKFailure(this.message);
}

class AvailabilityReason extends SDKFailure {
  AvailabilityReason(String message) : super(message);
}

class InvalidTokenReason extends SDKFailure {
  InvalidTokenReason(String message) : super(message);
}

class LibraryReason extends SDKFailure {
  LibraryReason(String message) : super(message);
}

class NetworkReason extends SDKFailure {
  NetworkReason(String message) : super(message);
}

class PermissionReason extends SDKFailure {
  PermissionReason(String message) : super(message);
}

class SecurityReason extends SDKFailure {
  SecurityReason(String message) : super(message);
}

class ServerReason extends SDKFailure {
  int code;

  ServerReason(String message, this.code) : super(message);
}

class StorageReason extends SDKFailure {
  StorageReason(String message) : super(message);
}