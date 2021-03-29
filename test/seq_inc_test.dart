import 'package:test/test.dart';
import 'package:nuid/src/seq_inc.dart';

void main() {
  group('SeqInc', () {
    test('random', () {
      final seqInc1 = SeqInc.random();
      final seqInc2 = SeqInc.random();
      expect(seqInc1.seq == seqInc2.seq && seqInc1.inc == seqInc2.inc, false);
    });

    test('contructor border cases', () {
      expect(
        () => SeqInc(4131, SeqInc.minInc - 1),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => SeqInc(4131, SeqInc.maxInc),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => SeqInc(-1, SeqInc.minInc),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => SeqInc(SeqInc.maxSeq + 1, SeqInc.minInc),
        throwsA(isA<AssertionError>()),
      );
    });

    test('next value in a non border case', () {
      const seqInc = SeqInc(50, 44);
      var called = false;
      final next = seqInc.next(() => called = true);
      expect(called, false);
      expect(next.seq, seqInc.seq + seqInc.inc);
      expect(next.inc, seqInc.inc);
    });

    test('next value in a border case', () {
      const seqInc = SeqInc(SeqInc.maxSeq - 20, 44);
      var called = false;
      seqInc.next(() => called = true);
      expect(called, true);
    });
  });
}
