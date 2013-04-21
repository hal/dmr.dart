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

class _ListValue extends ModelValue {

  List<ModelNode> _list;

  _ListValue() : super(ModelType.LIST) {
    _list = new List<ModelNode>();
  }

  _ListValue.from(List<ModelNode> list) : super(ModelType.LIST) {
    _list = new List<ModelNode>.from(list, growable: true);
  }

  int asNum([int onError(ModelValue value)]) => _list.length;

  bool asBool([bool onError(ModelValue value)]) => _list.isEmpty;

  String asString() {
    var buffer = new StringBuffer();
    _format(buffer, false);
    return buffer.toString();
  }

  Property asProperty() => _list.length == 2 ? new Property(_list[0].asString(), _list[1]) : super.asProperty();

  List<Property> asPropertyList() {
    var propertyList = new List<Property>();
    var iter = new HasNextIterator<ModelNode>(_list.iterator);
    while (iter.hasNext) {
      var node = iter.next();
      if (node.type == ModelType.PROPERTY) {
        propertyList.add(node.asProperty());
      } else if (iter.hasNext) {
        var value = iter.next();
        propertyList.add(new Property(node.asString(), value));
      }
    }
    return propertyList;
  }

  ModelNode asObject() {
    var node = new ModelNode();
    var iter = new HasNextIterator<ModelNode>(_list.iterator);
    while (iter.hasNext) {
      var name = iter.next();
      if (name.type == ModelType.PROPERTY) {
        var property = name.asProperty();
        node[property.name] = property.value;
      } else if (iter.hasNext) {
        var value = iter.next();
        node[name.asString()] = value;
      }
    }
    return node;
  }

  List<ModelNode> asList() => _list;

  ModelNode operator [](index) {
    var size = _list.length;
    if (size <= index) {
      for (int i = 0; i < index - size + 1; i ++) {
        _list.add(new ModelNode());
      }
    }
    return _list[index];
  }

  bool has(int index) => 0 <= index && index < _list.length;

  ModelNode require(index) => _list[index];

  ModelNode add() {
    var node = new ModelNode();
    _list.add(node);
    return node;
  }

  void protect() => _list.forEach((node) => node.protect());

  ModelValue copy() => new _ListValue.from(this._list);

  ModelValue resolve() {
    var resolved = _list.map((node) => node.resolve());
    return new _ListValue.from(resolved.toList());
  }

  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    } else if (other is _ListValue) {
      var i = -1;
      return _list.every((element) {
        i++;
        return (other as List)[i] == element;
      });
    }
    return false;
  }

  int get hashCode => _list.hashCode;

  void _format(StringBuffer buffer, bool json, [int indent = 0]) {
    var iter = new HasNextIterator<ModelNode>(_list.iterator);
    buffer.write("[");
    _indent(buffer..write("\n"), indent + 1);
    while (iter.hasNext) {
      var node = iter.next();
      node._format(buffer, json, indent + 1);
      if (iter.hasNext) {
        _indent(buffer..write(",\n"), indent + 1);
      }
    }
    _indent(buffer..write("\n"), indent);
    buffer.write("]");
  }

  void _writeExternal(_DataOutput output) {
    output.writeNum(_list.length, ModelType.INT);
    _list.forEach((node) => node._writeExternal(output));
  }
}
