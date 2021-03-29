/*!
 * Author: Frank Moreno <frankmoreno1993@gmail.com>
 * Copyright(c) 2021. All rights reserved.
 * MIT Licensed
 */
library nuid;

import 'dart:math' show Random;

/// {@template seq_inc}
/// A handler for `seq` and `inc` values
/// {@endtemplate}
///
/// {@template seq_inc_random}
/// Initializes the pseudo randmon sequence number and the increment range.
/// {@endtemplate}
class SeqInc {
  /// {@macro seq_inc}
  const SeqInc(this.seq, this.inc)
      : assert(seq >= 0 && seq <= maxSeq),
        assert(inc >= minInc && inc < maxInc);

  /// {@macro seq_inc_random}
  factory SeqInc.random() {
    final rng = Random();
    final seq = (rng.nextDouble() * maxSeq).floor();
    final inc = rng.nextInt(maxInc - minInc) + minInc;
    return SeqInc(seq, inc);
  }

  /// Initial value for generation of a sequence of bytes that increments
  /// in each step based on `inc`.
  final int seq;

  /// A random number between `minInc` and `maxInc` for incrementing `seq`
  /// for the `next` generation.
  final int inc;

  /// Maximum value for `seq`
  static const int maxSeq = 3656158440062976; // base^seqLen == 36^10

  /// Minimum value for `inc`
  static const int minInc = 33;

  /// Maximum value for `inc`
  static const int maxInc = 333;

  /// Generate the next [SeqInc] based on the current value
  /// and invokes a callback `onReset`.
  SeqInc next(void Function() onReset) {
    final _seq = seq + inc;
    if (_seq > maxSeq) {
      onReset();
      return SeqInc.random();
    }
    return SeqInc(_seq, inc);
  }
}
