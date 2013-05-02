/*
 * JBoss, Home of Professional Open Source.
 * Copyright 2013, Red Hat, Inc., and individual contributors
 * as indicated by the @author tags. See the copyright.txt file in the
 * distribution for a full listing of individual contributors.
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

part of dmr;

// TODO Implement

class _DataOutput {

  List<int> _bytes;

  _DataOutput() {
    _bytes = new List<int>();
  }

  List<int> get bytes => _bytes;

  void writeByte(int v) => _bytes.add(v);

  void writeBytes(List<int> b) => _bytes.addAll(b);

  void writeBool(bool v) => _bytes.add(v ? 1 : 0);

  void writeNum(num v, ModelType type) {
    // TODO Work with fixnums before turning them into bytes!
    switch (type) {
      case ModelType.INT:
        var list = new Int8List(4);
        var data = new ByteData.view(list.buffer);
        data.setInt32(0, v);
        _bytes.addAll(list);
        break;
      case ModelType.LONG:
        var list = new Int8List(8);
        var data = new ByteData.view(list.buffer);
        data.setInt64(0, v);
        _bytes.addAll(list);
        break;
      case ModelType.DOUBLE:
        var list = new Int8List(8);
        var data = new ByteData.view(list.buffer);
        data.setFloat64(0, v);
        _bytes.addAll(list);
        break;
      case ModelType.BIG_DECIMAL:
      case ModelType.BIG_INTEGER:
        throw new UnsupportedError("Decoding / encoding ${ModelType.BIG_INTEGER} and ${ModelType.BIG_DECIMAL} is not supported yet!");
    }
  }

  void writeUtf(String s) {
    var sBytes = new List<int>();
    for (var i = 0; i < s.length; i ++) {
      var c = s.codeUnitAt(i);
      if (c > 0 && c <= 0x7f) {
        sBytes.add(c);
      } else if (c <= 0x07ff) {
        sBytes.add((0xc0 | 0x1f & c >> 6));
        sBytes.add((0x80 | 0x3f & c));
      } else {
        sBytes.add((0xe0 | 0x0f & c >> 12));
        sBytes.add((0x80 | 0x3f & c >> 6));
        sBytes.add((0x80 | 0x3f & c));
      }
    }
    // write length as "short"
    var list = new Int8List(2);
    var data = new ByteData.view(list.buffer);
    data.setInt16(0, sBytes.length);
    _bytes.addAll(list);
    writeBytes(sBytes);
  }
}
