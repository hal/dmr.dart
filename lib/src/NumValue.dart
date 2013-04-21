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

class _NumValue extends ModelValue {

  final num _value;

  const _NumValue(this._value, ModelType type) : super(type);

  int asNum([num onError(ModelValue value)]) => _value;

  bool asBool([bool onError(ModelValue value)]) => _value != 0;

  String asString() => _value.toString();

  List<int> asBytes() {
    var output = new _DataOutput();
    output.writeNum(_value, type);
    return output.bytes;
  }

  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    } else if (other is _NumValue) {
      return _value == (other as _NumValue)._value;
    }
    return false;
  }

  int get hashCode => _value.hashCode;

  void _writeExternal(_DataOutput output) => output.writeNum(_value, type);
}
