/// Sealed failure hierarchy for the storage layer (SharedPreferences backed).
///
/// Each subtype carries a human-readable [message] (suitable for logging or UI)
/// and an optional [cause] for debugging. They are intentionally independent
/// from `SealedResult` so callers can throw or return them directly.
sealed class StorageFailure {
  const StorageFailure(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() =>
      '$runtimeType($message${cause == null ? '' : ', cause: $cause'})';
}

/// SharedPreferences could not be loaded (e.g. platform channel error).
class PreferencesUnavailable extends StorageFailure {
  const PreferencesUnavailable({String? message, Object? cause})
      : super(message ?? 'SharedPreferences unavailable', cause: cause);
}

/// A stored JSON entry could not be decoded.
class CorruptedEntry extends StorageFailure {
  const CorruptedEntry(this.key, {Object? cause})
      : super('Corrupted entry for key: $key', cause: cause);

  final String key;
}

/// A requested record was not found.
class NotFound extends StorageFailure {
  const NotFound(this.identifier, {Object? cause})
      : super('Not found: $identifier', cause: cause);

  final String identifier;
}
