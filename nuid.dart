/*!
 * Author: Frank Moreno <frankmoreno1993@gmail.com>
 * Copyright(c) 2017 Geckotronics SAC. All rights reserved.
 * MIT Licensed
 */
library nuid;

import 'dart:math' as Math;
import 'package:crypto/crypto.dart';

const String digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const int base = 36;
const int preLen = 12;
const int seqLen = 10;
const int maxSeg = 3656158440062976;  // base^seqLen == 36^10
const int minInc   = 33;
const int maxInc   = 333;
const int totalLen = preLen + seqLen;

class Nuid {
  byte[] buf;

  // Create and initialize a nuid.
  Nuid(){
    this.buf = new Buffer(totalLen);
    this._setPre();
    this._initSeqAndInc();
    this._fillSeq();
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
    this.seq = Math.floor(Math.random() * maxSeq);
    this.inc = Math.floor(Math.random() * (maxInc-minInc)+minInc);
  }

  // Sets the prefix from crypto random bytes. Converts to base36.
  void _setPre() {
    var cbuf = crypto.randomBytes(preLen);
    for (var i = 0; i < preLen; i++) {
      var di = cbuf[i] % base;
      this.buf[i] = digits.charCodeAt(di);
    }
  }

  // Fills the sequence part of the nuid as base36 from this.seq.
  void _fillSeq() {
    var n = this.seq;
    for (var i = totalLen-1; i >= preLen; i--) {
      this.buf[i] = digits.charCodeAt(n%base);
      n = Math.floor(n/base);
    }
  }

  // Returns the next nuid
  static void next() {
    this.seq += this.inc;
    if (this.seq > maxSeq) {
      this.setPre();
      this.initSeqAndInc();
    }
    this.fillSeq();
  }
    return (this.buf.toString('ascii'));
}



/* Global Nuid */
Nuid nuid = new Nuid();
