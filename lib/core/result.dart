/// Represents the outcome of an operation that can either succeed with a value
/// or fail with a message and an optional underlying cause.
///
/// Pattern-match on the concrete subtypes (`Success`, `Failure`) for
/// exhaustive handling, or use [SealedResult.when] / [SealedResult.valueOrNull]
/// for lightweight checks.
sealed class SealedResult<T> {
  const SealedResult();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  /// Returns the wrapped value or `null` when this is a [Failure].
  T? get valueOrNull => switch (this) {
        Success<T>(value: final v) => v,
        Failure<T>() => null,
      };

  /// Pattern-matches the result and invokes [success] or [failure].
  R when<R>({
    required R Function(T value) success,
    required R Function(Failure<T> failure) failure,
  }) {
    final self = this;
    if (self is Success<T>) {
      return success(self.value);
    }
    return failure(self as Failure<T>);
  }
}

final class Success<T> extends SealedResult<T> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Success<T> && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

final class Failure<T> extends SealedResult<T> {
  const Failure(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          other.message == message &&
          other.cause == cause;

  @override
  int get hashCode => Object.hash(message, cause);

  @override
  String toString() => 'Failure($message${cause == null ? '' : ', cause: $cause'})';
}
