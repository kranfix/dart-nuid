import 'package:test/test.dart';
import 'package:nuid/nuid.dart';

bool isRangeEqual(
  List<int> buffer1,
  List<int> buffer2, [
  int start = 0,
  int? end,
]) {
  end ??= buffer2.length;
  for (var i = start; i < end; i++) {
    if (buffer1[i] != buffer2[i]) {
      return false;
    }
  }
  return true;
}

void main() {
  group('Basics', () {
    final nuid = Nuid.instance;

    test('global nuid should not be null', () {
      expect(nuid, isNotNull);
      expect(nuid.buffer, isNotNull);
      expect(nuid.buffer.length, greaterThan(0));
      expect(nuid.seq, isNotNull);
      expect(nuid.seq, greaterThan(0));
      expect(nuid.inc, isNotNull);
    });

    test('duplicate nuids', () {
      final m = <String, dynamic>{};
      // make this really big when testing, for normal runs small
      for (var i = 0; i < 10000; i++) {
        final k = nuid.next();
        expect(m[k], isNull);
        m[k] = true;
      }
    }, timeout: const Timeout(Duration(seconds: 1000)));

    test('roll seq', () {
      final a = List<int>.filled(10, 0, growable: false)
        ..setAll(0, nuid.buffer.getRange(12, 22));
      nuid.next();

      final b = List<int>.filled(10, 0, growable: false)
        ..setAll(0, nuid.buffer.getRange(12, 22));
      expect(isRangeEqual(a, b), isFalse);
    });

    test('roll pre', () {
      nuid.seq = 3656158440062976 + 1;
      final a = List<int>.filled(12, 0, growable: false)
        ..setAll(0, nuid.buffer.getRange(0, 12));

      nuid.next();

      final b = List<int>.filled(12, 0, growable: false)
        ..setAll(0, nuid.buffer.getRange(0, 12));
      expect(isRangeEqual(a, b), isFalse);
    });

    test('reset should reset', () {
      final a = nuid.buffer;
      nuid.reset();
      final b = nuid.buffer;

      expect(isRangeEqual(a, b, 0, 12), isFalse);
      expect(isRangeEqual(a, b, 12), isFalse);
    });
  });
}
