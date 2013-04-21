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

class _ObjectValue extends ModelValue {

  Map<String, ModelNode> _data;

  _ObjectValue() : super(ModelType.OBJECT) {
    _data = new LinkedHashMap();
  }

  _ObjectValue.from(Map<String, ModelNode> data) : super(ModelType.OBJECT) {
    _data = data;
  }

  int asInt([int onError(ModelValue value)]) => _data.length;

  bool asBool([bool onError(ModelValue value)]) => _data.isEmpty;

  String asString() {
    var buffer = new StringBuffer();
    _format(buffer, false);
    return buffer.toString();
  }

  Property asProperty() => _data.length == 1 ? new Property(_data.keys.first, _data.values.first) : super.asProperty();

  List<Property> asPropertyList() {
    var propertyList = new List<Property>();
    _data.forEach((key, value) => propertyList.add(new Property(key, value)));
    return propertyList;
  }

  ModelNode asObject() {
    return new ModelNode.from(copy());
  }

  List<ModelNode> asList() {
    var nodes = new List<ModelNode>();
    _data.forEach((key, value) {
      var node = new ModelNode();
      node.setProperty(key, value);
      nodes.add(node);
    });
    return nodes;
  }

  ModelNode operator [](String key) {
    if (key == null) {
      return null;
    }
    var node = _data[key];
    if (node != null) {
      return node;
    }
    var newNode = new ModelNode();
    _data[key] = newNode;
    return newNode;
  }

  bool has(String key) => _data.containsKey(key);

  ModelNode require(String key) {
    var node = _data[key];
    if (node != null) {
      return node;
    }
    return super.require(key);
  }

  ModelNode remove(String key) {
    if (key == null) {
      return null;
    }
    return _data.remove(key);
  }

  Iterable<String> get keys => _data.keys;

  void protect() => _data.values.forEach((node) => node.protect());

  ModelValue copy() => _copy(false);

  ModelValue resolve() => _copy(true);

  ModelValue _copy(bool resolve) {
    var newData = new LinkedHashMap<String, ModelNode>();
    _data.forEach((key, value) {
      newData[key] = resolve ? value.resolve() : value.clone();
    });
    return new _ObjectValue.from(newData);
  }

  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    } else if (other is _ObjectValue) {
      // compare keys
      var keys = _data.keys;
      var otherKeys = (other as _ObjectValue)._data.keys;
      var sameKeys = keys.length == otherKeys.length;
      if (sameKeys) {
        var iter = keys.iterator;
        var otherIter = otherKeys.iterator;
        while (iter.moveNext() && otherIter.moveNext()) {
          if (iter.current != otherIter.current) {
            sameKeys = false;
            break;
          }
        }
      }
      // compare values
      var values = _data.values;
      var otherValues = (other as _ObjectValue)._data.values;
      var sameValues = values.length == otherValues.length;
      if (sameValues) {
        var iter = values.iterator;
        var otherIter = otherValues.iterator;
        while (iter.moveNext() && otherIter.moveNext()) {
          if (iter.current != otherIter.current) {
            sameValues = false;
            break;
          }
        }
      }
      return sameKeys && sameValues;
    }
    return false;
  }

  int get hashCode => _data.hashCode;

  void _format(StringBuffer buffer, bool json, [int indent = 0]) {
    var iter = new HasNextIterator<String>(_data.keys.iterator);
    buffer.write("{");
    _indent(buffer..write("\n"), indent + 1);
    while (iter.hasNext) {
      var key = iter.next();
      var value = _data[key];
      buffer
        ..write(stringify(key))
        ..write(json ? " : " : " => ");
        value._format(buffer, json, indent + 1);
      if (iter.hasNext) {
        _indent(buffer..write(",\n"), indent + 1);
      }
    }
    _indent(buffer..write("\n"), indent);
    buffer.write("}");
  }

  void _writeExternal(_DataOutput output) {
    output.writeNum(_data.length, ModelType.INT);
    _data.forEach((key, value) {
      output.writeUtf(key);
      value._writeExternal(output);
    });
  }
}
