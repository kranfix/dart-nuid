/*!
 * Author: Frank Moreno <frankmoreno1993@gmail.com>
 * Copyright(c) 2017 Geckotronics SAC. All rights reserved.
 * MIT Licensed
 */
library nuid;

import 'dart:math' as Math;
import 'dart:typed_data';

const String digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const int base = 36;
const int preLen = 12;
const int seqLen = 10;
const int maxSeq = 3656158440062976;  // base^seqLen == 36^10
const int minInc   = 33;
const int maxInc   = 333;
const int totalLen = preLen + seqLen;

class Nuid {
  var buf;
  num seq;
  num inc;

  // Create and initialize a nuid.
  Nuid(){
    this.buf = new Uint8List(totalLen);
    this._init();
  }

  // Initializes a nuid with a crypto random prefix,
  // and pseudo-random sequence and increment.
  void _init(){
    this._setPre();
    this._initSeqAndInc();
    this._fillSeq();
  }
  void reset() {
    this._init();
  }

  // Initializes the pseudo randmon sequence number and the increment range.
  void _initSeqAndInc() {
    var rng = new Math.Random();
    this.seq = (rng.nextDouble() * maxSeq).floor();
    this.inc = rng.nextInt(maxInc-minInc) + minInc;
  }

  // Sets the prefix from crypto random bytes. Converts to base36.
  void _setPre() {
    var rs = new Math.Random.secure();
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
    return new String.fromCharCodes(this.buf);
    //return this.buf.toString();
  }
}



/* Global Nuid */
Nuid nuid = new Nuid();
