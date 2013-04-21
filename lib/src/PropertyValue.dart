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

class _PropertyValue extends ModelValue {

  static const String TYPE_KEY = "PROPERTY_VALUE";

  final Property _property;

  const _PropertyValue(this._property) : super(ModelType.PROPERTY);

  _PropertyValue.nameValue(String name, ModelNode value) : this(new Property(name, value));

  String asString() => "(${stringify(_property.name)} => $_property.value)";

  Property asProperty() => _property;

  List<Property> asPropertyList() => [_property];

  ModelNode asObject() {
    var node = new ModelNode();
    node[_property.name] = _property.value;
    return node;
  }

  List<ModelNode> asList() => [new ModelNode.from(this)];

  ModelNode operator [](indexOrName) {
    if (indexOrName == 0 || indexOrName == _property.name) {
      return _property.value;
    }
    throw new RangeError.value(indexOrName);
  }

  bool has(String name) => name == _property.name;

  ModelNode require(String name) => name == _property.name ? _property.value : super.require(name);

  Iterable<String> get keys => [_property.name].toSet();

  void protect() => _property.value.protect();

  ModelValue copy() => new _PropertyValue.nameValue(_property.name, _property.value);

  ModelValue resolve() => new _PropertyValue.nameValue(_property.name, _property.value.resolve());

  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    } else if (other is _PropertyValue) {
      return _property == (other as _PropertyValue)._property;
    }
    return false;
  }

  int get hashCode => _property.hashCode;

  void _format(StringBuffer buffer, bool json, [int indent = 0]) {
    if (json) {
      buffer.write("{");
      _indent(buffer..write("\n"), indent + 1);
      buffer..write(TYPE_KEY)..write(" : ");
      _asJson(buffer, indent + 1);
      _indent(buffer..write("\n"), indent);
      buffer.write("}");
    } else {
      super._format(buffer, json, indent);
    }
  }

  void _asJson(StringBuffer buffer, int indent) {
    buffer.write("{");
    _indent(buffer..write("\n"), indent + 1);
    buffer..write(stringify(_property.name))..write(" : ");
    _property.value._format(buffer, true, indent);
    _indent(buffer..write("\n"), indent);
    buffer.write('}');
  }

  void _writeExternal(_DataOutput output) {
    output.writeUtf(_property.name);
    _property.value._writeExternal(output);
  }
}
