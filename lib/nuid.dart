/*!
 * Author: Frank Moreno <frankmoreno1993@gmail.com>
 * Copyright(c) 2018 ariot.pe. All rights reserved.
 * MIT Licensed
 */
library nuid;

import 'dart:math' show Random;

import 'package:meta/meta.dart';

/// Nuid means NATS UID
///
/// NATS is a communication protocol and need an optimized way to generate
/// UIDs for the protocol.
///
/// The [Nuid] is an implementation of the `NUID` algorithm based of
/// the Node.js nuid package
///
/// ```dart
/// final nuid = Nuid.instance;
///
/// print('String:');
/// print('  First nuid:');
/// for (var i = 0; i < 4; i++) {
///   print('  - ${nuid.next()}');
/// }
///
/// print('  Reseting nuid:');
/// nuid.reset();
///
/// for (var i = 0; i < 4; i++) {
///   print('  - ${nuid.next()}');
/// }
///
/// print('\nBytes:');
/// print('  First nuid:');
/// for (var i = 0; i < 4; i++) {
///   print('  - ${nuid.nextBytes()}');
/// }
///
/// print('  Reseting nuid:');
/// nuid.reset();
///
/// for (var i = 0; i < 4; i++) {
///   print('  - ${nuid.nextBytes()}');
/// }
/// ```
class Nuid {
  /// Create and initialize a [Nuid].
  Nuid()
      : inc = 0,
        seq = 0,
        _buf = List<int>.filled(totalLen, 0, growable: false) {
    reset();
  }

  /// Valid digits for Nuid (base36)
  static const String digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// `digits` in [List<int>] format (i.e. as char array)
  static List<int> get binaryDigits => digits.runes.toList();

  /// Number of possible digits for an [Nuid]
  static const int base = 36;

  /// Number of static prefix of the [Nuid]
  static const int preLen = 12;

  /// Number of variable suffix of the [Nuid]
  static const int seqLen = 10;

  /// Maximum value for `seq`
  static const int maxSeq = 3656158440062976; // base^seqLen == 36^10

  /// Minimum value for `inc`
  static const int minInc = 33;

  /// Maximum value for `inc`
  static const int maxInc = 333;

  /// Length of a [Nuid]
  static const int totalLen = preLen + seqLen;

  /// Global [Nuid] instance
  static final Nuid instance = Nuid();

  final List<int> _buf;

  /// Initial value for generation of a sequence of bytes that increments
  /// in each step based on `inc`.
  int seq;

  /// A random number between `minInc` and `maxInc` for incrementing `seq`
  /// for the `next` generation.
  @visibleForTesting
  int inc;

  /// Makes a copy to keep the `_buf` inmutable
  List<int> get buffer => _buf.toList();

  /// Return the buffer as [String]
  String get current => String.fromCharCodes(_buf);

  /// Initializes or reinitializes a nuid with a crypto random prefix,
  /// and pseudo-random sequence and increment.
  void reset() {
    _setPre();
    _initSeqAndInc();
    _fillSeq();
  }

  /// Initializes the pseudo randmon sequence number and the increment range.
  void _initSeqAndInc() {
    final rng = Random();
    seq = (rng.nextDouble() * maxSeq).floor();
    inc = rng.nextInt(maxInc - minInc) + minInc;
  }

  /// Sets the prefix from crypto random bytes. Converts to base36.
  void _setPre() {
    final rs = Random.secure();
    for (var i = 0; i < preLen; i++) {
      final di = rs.nextInt(21701) % base;
      _buf[i] = digits.codeUnitAt(di);
    }
  }

  /// Fills the sequence part of the nuid as base36 from `seq`.
  void _fillSeq() {
    var n = seq;
    for (var i = totalLen - 1; i >= preLen; i--) {
      _buf[i] = digits.codeUnitAt(n % base);
      n = (n / base).floor();
    }
  }

  /// Returns the next [Nuid]
  String next() {
    _next();
    return current;
  }

  /// Returns the next [Nuid] as a [List<int>]
  List<int> nextBytes() {
    _next();
    return buffer;
  }

  void _next() {
    seq += inc;
    if (seq > maxSeq) {
      _setPre();
      _initSeqAndInc();
    }
    _fillSeq();
  }
}
