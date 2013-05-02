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

class _BytesValue extends ModelValue {

  static const String TYPE_KEY = "BYTES_VALUE";

  final List<int> _bytes;

  const _BytesValue(this._bytes) : super(ModelType.BYTES);

  num asNum([num onError(ModelValue value)]) {
    var length = _bytes.length;
    var cnt = min(8, length);
    var v = 0;
    for (var i = 0; i < cnt; i++) {
      v <<= 8;
      v |= _bytes[length - cnt + i] & 0xff;
    }
    return v;
  }

  String asString() {
    var buffer = new StringBuffer();
    _format(buffer, false);
    return buffer.toString();
  }

  List<int> asBytes() => _bytes;

  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }
    else if (other is _BytesValue) {
      return _bytes == (other as _BytesValue)._bytes;
    }
    return false;
  }

  int get hashCode => _bytes.hashCode;

  void _format(StringBuffer buffer, bool json, [int indent = 0]) {
    if (json) {
      buffer.write("{");
      _indent(buffer..write("\n"), indent + 1);
      buffer..write(TYPE_KEY)..write(" : ")..write(CryptoUtils.bytesToBase64(_bytes));
      _indent(buffer..write("\n"), indent);
      buffer.write("}");
    } else {
      var csb = _bytes.map((b) => "${b.toRadixString(16)}").join(", ");
      buffer..write("bytes {")..write(csb)..write("}");
    }
  }

  void _writeExternal(_DataOutput output) {
    output.writeNum(_bytes.length, ModelType.INT);
    output.writeBytes(_bytes);
  }
}
