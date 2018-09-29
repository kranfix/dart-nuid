/*!
 * Author: Frank Moreno <frankmoreno1993@gmail.com>
 * Copyright(c) 2018 ariot.pe. All rights reserved.
 * MIT Licensed
 */
library nuid;

import 'dart:math' as Math;

const String digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
final List<int> b_digits = digits.runes.toList();
const int base = 36;
const int preLen = 12;
const int seqLen = 10;
const int maxSeq = 3656158440062976;  // base^seqLen == 36^10
const int minInc   = 33;
const int maxInc   = 333;
const int totalLen = preLen + seqLen;

class Nuid {
  List<int> buf;
  num seq;
  num inc;

  // Create and initialize a nuid.
  Nuid(){
    this.buf = List<int>(totalLen);
    this.reset();
  }

  // Initializes a nuid with a crypto random prefix,
  // and pseudo-random sequence and increment.
  void reset(){
    this._setPre();
    this._initSeqAndInc();
    this._fillSeq();
  }

  // Initializes the pseudo randmon sequence number and the increment range.
  void _initSeqAndInc() {
    var rng = Math.Random();
    this.seq = (rng.nextDouble() * maxSeq).floor();
    this.inc = rng.nextInt(maxInc-minInc) + minInc;
  }

  // Sets the prefix from crypto random bytes. Converts to base36.
  void _setPre() {
    var rs = Math.Random.secure();
    for (var i = 0; i < preLen; i++) {
      var di = rs.nextInt(21701) % base;
      this.buf[i] = digits.codeUnitAt(di);
    }
  }

  // Fills the sequence part of the nuid as base36 from this.seq.
  void _fillSeq() {
    var n = this.seq;
    for (var i = totalLen-1; i >= preLen; i--) {
      this.buf[i] = digits.codeUnitAt(n % base);
      n = (n/base).floor();
    }
  }

  // Returns the next nuid
  String next() {
    this.seq += this.inc;
    if (this.seq > maxSeq) {
      this._setPre();
      this._initSeqAndInc();
    }
    this._fillSeq();
    return String.fromCharCodes(this.buf);
  }

  List<int> next_bytes(){
    this.seq += this.inc;
    if (this.seq > maxSeq) {
      this._setPre();
      this._initSeqAndInc();
    }
    this._fillSeq();
    return this.buf;
  }
}



/* Global Nuid */
Nuid nuid = new Nuid();
