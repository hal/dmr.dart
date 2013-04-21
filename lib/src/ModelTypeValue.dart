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

class _ModelTypeValue extends ModelValue {

  static const String TYPE_KEY = "TYPE_MODEL_VALUE";

  static const _BIG_DECIMAL = const _ModelTypeValue._internal(ModelType.BIG_DECIMAL);
  static const _BIG_INTEGER = const _ModelTypeValue._internal(ModelType.BIG_INTEGER);
  static const _BOOLEAN = const _ModelTypeValue._internal(ModelType.BOOLEAN);
  static const _BYTES = const _ModelTypeValue._internal(ModelType.BYTES);
  static const _DOUBLE = const _ModelTypeValue._internal(ModelType.DOUBLE);
  static const _INT = const _ModelTypeValue._internal(ModelType.INT);
  static const _LIST = const _ModelTypeValue._internal(ModelType.LIST);
  static const _LONG = const _ModelTypeValue._internal(ModelType.LONG);
  static const _OBJECT = const _ModelTypeValue._internal(ModelType.OBJECT);
  static const _STRING = const _ModelTypeValue._internal(ModelType.STRING);
  static const _TYPE = const _ModelTypeValue._internal(ModelType.TYPE);
  static const _UNDEFINED = const _ModelTypeValue._internal(ModelType.UNDEFINED);

  final ModelType _modelType;

  const _ModelTypeValue._internal(this._modelType) : super(ModelType.TYPE);

  factory _ModelTypeValue(ModelType type) {
    switch (type) {
      case ModelType.BIG_DECIMAL: return _BIG_DECIMAL; break;
      case ModelType.BIG_INTEGER: return _BIG_INTEGER; break;
      case ModelType.BOOLEAN: return _BOOLEAN; break;
      case ModelType.BYTES: return _BYTES; break;
      case ModelType.DOUBLE: return _DOUBLE; break;
      case ModelType.INT: return _INT; break;
      case ModelType.LIST: return _LIST; break;
      case ModelType.LONG: return _LONG; break;
      case ModelType.OBJECT: return _OBJECT; break;
      case ModelType.STRING: return _STRING; break;
      case ModelType.TYPE: return _TYPE; break;
      default: return _UNDEFINED; break;
    }
  }

  bool asBool([bool onError(ModelValue value)]) => _modelType != ModelType.UNDEFINED;

  ModelType asType() => _modelType;

  String asString() => _modelType.toString();

  bool operator ==(other) => identical(other, this);

  int get hashCode => _modelType.hashCode;

  void _format(StringBuffer buffer, bool json, [int indent = 0]) {
    if (json) {
      buffer.write("{");
      _indent(buffer..write("\n"), indent + 1);
      buffer..write(TYPE_KEY)..write(" : ")..write(stringify(asString()));
      _indent(buffer..write("\n"), indent);
      buffer.write("}");
    } else {
      super._format(buffer, json, indent);
    }
  }

  void _writeExternal(_DataOutput output) => output.writeByte(_modelType.id.codeUnitAt(0));
}
