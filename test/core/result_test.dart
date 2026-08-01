import 'package:flutter_test/flutter_test.dart';
import 'package:score_beloty_2_0/core/result.dart';

void main() {
  group('SealedResult', () {
    test('Success.isSuccess and valueOrNull', () {
      const result = Success<int>(42);
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.valueOrNull, 42);
    });

    test('Failure.isFailure and valueOrNull', () {
      const result = Failure<int>('boom');
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.valueOrNull, isNull);
    });

    test('Failure carries an optional cause', () {
      final result = Failure<int>('boom', cause: StateError('x'));
      expect(result.message, 'boom');
      expect(result.cause, isA<StateError>());
    });

    test('when dispatches to the right branch', () {
      const ok = Success<int>(10);
      const ko = Failure<int>('nope');

      expect(
        ok.when(success: (v) => 'ok:$v', failure: (f) => 'err:${f.message}'),
        'ok:10',
      );
      expect(
        ko.when(success: (v) => 'ok:$v', failure: (f) => 'err:${f.message}'),
        'err:nope',
      );
    });

    test('Success and Failure are equal when their fields match', () {
      expect(const Success<int>(1) == const Success<int>(1), isTrue);
      expect(const Failure<int>('m') == const Failure<int>('m'), isTrue);
      // ignore: unrelated_type_equality_checks
      expect(const Success<int>(1) == const Failure<int>('m'), isFalse);
    });
  });
}
