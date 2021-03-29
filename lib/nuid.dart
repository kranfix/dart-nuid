/*!
 * Author: Frank Moreno <frankmoreno1993@gmail.com>
 * Copyright(c) 2018 ariot.pe. All rights reserved.
 * MIT Licensed
 */
library nuid;

import 'dart:math' show Random;
import 'src/seq_inc.dart';

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
  Nuid([SeqInc? seqInc])
      : _seqInc = seqInc ?? SeqInc.random(),
        _buf = List<int>.filled(totalLen, 0, growable: false) {
    reset(false);
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

  /// Length of a [Nuid]
  static const int totalLen = preLen + seqLen;

  /// Global [Nuid] instance
  static final Nuid instance = Nuid();

  final List<int> _buf;

  SeqInc _seqInc;

  /// Makes a copy to keep the `_buf` inmutable
  List<int> get buffer => _buf.toList();

  /// Return the buffer as [String]
  String get current => String.fromCharCodes(_buf);

  /// Initializes or reinitializes a nuid with a crypto random prefix,
  /// and pseudo-random sequence and increment.
  void reset([bool seqInc = true]) {
    _setPre();
    if (seqInc) _seqInc = SeqInc.random();
    _fillSeq(_seqInc.seq);
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
  void _fillSeq(int n) {
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
    _seqInc = _seqInc.next(_setPre);
    _fillSeq(_seqInc.seq);
  }
}
