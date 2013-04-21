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

class _DataInput {

  int _pos = 0;

  List<int> _bytes;

  Iterator<int> _iter;

  _DataInput(this._bytes) {
    this._iter = this._bytes.iterator;
  }

  int readByte() {
    if (_iter.moveNext()) {
      return _iter.current;
    }
    throw new RangeError("No more bytes to read");
  }

  List<int> readBytes(num size) {
    var bytes = new List<int>(size);
    for (var i = 0; i < size; i++) {
      bytes[i] = readByte();
    }
    return bytes;
  }

  bool readBool() => readByte() != 0;

  num readNum(ModelType type) {
    if (type == ModelType.INT) {
      var list = new Int8List.fromList(readBytes(4).reversed.toList());
      var data = new ByteData.view(list.buffer);
      return data.getInt32(0);
    } else if (type == ModelType.LONG) {
      var list = new Int8List.fromList(readBytes(8).reversed.toList());
      var data = new ByteData.view(list.buffer);
      return data.getInt64(0);
    } else if (type == ModelType.DOUBLE) {
      var list = new Int8List.fromList(readBytes(8).reversed.toList());
      var data = new ByteData.view(list.buffer);
      return data.getFloat64(0);
    } else {
      throw new ArgumentError("Invalid type: readNum($type)");
    }
  }

  String readUtf() {
    // read length as "short"
    var list = new Int8List.fromList(readBytes(2).reversed.toList());
    var data = new ByteData.view(list.buffer);
    int bytes = data.getInt16(0);
    var buffer = new StringBuffer();
    while (bytes > 0) {
      bytes -= readUtfChar(buffer);
    }
    return buffer.toString();
  }

  int readUtfChar(StringBuffer buffer) {
    int a = readByte();
    if (a < 0x80) {
      buffer.write(new String.fromCharCode(a));
      return 1;
    } else if (a < 0xc0) {
      buffer.write("?");
      return 1;
    } else if (a < 0xe0) {
      int b = readByte();
      if ((b & 0xc0) != 0x80) {
        buffer.write("?");
        buffer.write(new String.fromCharCode(b));
      } else {
        buffer.write(new String.fromCharCode(((a & 0x1F) << 6 | b & 0x3F)));
      }
      return 2;
    } else if (a < 0xf0) {
      int b = readByte();
      if ((b & 0xc0) != 0x80) {
        buffer.write("?");
        buffer.write(new String.fromCharCode(b));
        return 2;
      }
      int c = readByte();
      if ((c & 0xc0) != 0x80) {
        buffer.write("??");
        buffer.write(new String.fromCharCode(c));
      } else {
        buffer.write(new String.fromCharCode(((a & 0x0F) << 12 | (b & 0x3F) << 6 | c & 0x3F)));
      }
      return 3;
    } else {
      buffer.write("?");
      return 1;
    }
  }
}
