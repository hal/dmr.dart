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

class _StringValue extends ModelValue {

  final String _value;

  const _StringValue(this._value) : super(ModelType.STRING);

  num asNum([num onError(ModelValue value)]) {
    var fraction = _value.contains(new RegExp(r"\."));
    if (?onError) {
      if (fraction) {
        return double.parse(_value, (s) => onError(this));
      } else {
        return int.parse(_value, onError: (s) => onError(this));
      }
    } else {
      if (fraction) {
        return double.parse(_value);
      } else {
        return int.parse(_value);
      }
    }
  }

  bool asBool([bool onError(ModelValue value)]) {
    if (_value == "true") {
      return true;
    } else {
      return (?onError) ? onError(this) : false;
    }
  }

  String asString() => _value;

  List<int> asBytes() => _value.codeUnits;

  ModelType asType() => new ModelType(_value);

  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    } else if (other is _StringValue) {
      return _value == (other as _StringValue)._value;
    }
    return false;
  }

  int get hashCode => _value.hashCode;

  void _format(StringBuffer buffer, bool json, [int indent = 0]) => buffer.write(stringify(_value));

  void _writeExternal(_DataOutput output) => output.writeUtf(_value);
}
