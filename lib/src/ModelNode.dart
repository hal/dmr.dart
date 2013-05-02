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

/**
 * A dynamic model representation node object.
 */
class ModelNode {

  static const int MIN_INT = -2147483648;
  static const int MAX_INT = 2147483647;
  static const String OUTCOME = "outcome";
  static const String SUCCESS = "success";
  static const String FAILURE_DESCRIPTION = "failure-description";

  bool _protect;

  ModelValue _value;

  Map<String, dynamic> tags;

  ModelNode() {
    _protect = false;
    tags = new Map<String, dynamic>();
    _value = new _UndefinedValue();
  }

  ModelNode.from(ModelValue value) {
    _protect = false;
    tags = new Map<String, dynamic>();
    _value = value;
  }


  //---------------------------------------- as methods

  /**
   * Get the value of this node as an `num`. Collection types will return the size
   * of the collection for this value.  Other types may attempt a string conversion.
   *
   * If no conversion is possible, the [onError] is called with the [value] as argument, and its return
   * value is used instead. If no [onError] is provided, a [FormatException] is thrown.
   */
  num asNum([num onError(ModelValue value)]) => _value.asNum(onError);

  /**
   * Get the value of this node as an `bool`. Collection types return `true` for non-empty
   * collections. Numerical types return `true` for non-zero values.
   *
   * If no conversion is possible, the [onError] is called with the [value] as argument, and its return
   * value is used instead. If no [onError] is provided, a [FormatException] is thrown.
   */
  bool asBool([bool onError(ModelValue value)]) => _value.asBool(onError);

  /**
   * Get the value as a string. This is the literal value of this model node. More than one node type may
   * yield the same value for this method.
   */
  String asString() => _value.asString();

  /**
   * Get the value of this node as a byte array.  Strings and string-like values will return
   * the UTF-8 encoding of the string.  Numerical values will return the byte representation of the
   * number.
   */
  List<int> asBytes() => _value.asBytes();

  /**
   * Get the value of this node as a property. Object values will return a property if there is exactly one
   * property in the object. List values will return a property if there are exactly two items in the list,
   * and if the first is convertible to a string.
   *
   * Throws a [FormatException] if no conversion is possible.
   */
  Property asProperty() => _value.asProperty();

  /**
   * Get the value of this node as a property list. Object values will return a list of properties representing
   * each key-value pair in the object. List values will return all the values of the list, failing if any of the
   * values are not convertible to a property value.
   *
   * Throws a [FormatException] if no conversion is possible.
   */
  List<Property> asPropertyList() => _value.asPropertyList();

  /**
   * Get a copy of this value as an object. Object values will simply copy themselves as by the [clone] method.
   * Property values will return a single-entry object whose key and value are copied from the property key and value.
   * List values will attempt to interpolate the list into an object by iterating each item, mapping each property
   * into an object entry and otherwise taking pairs of list entries, converting the first to a string, and using the
   * pair of entries as a single object entry.  If an object key appears more than once in the source object, the last
   * key takes precedence.
   *
   * Throws a [FormatException] if no conversion is possible.
   */
  ModelNode asObject() => _value.asObject();

  /**
   * Get the value of this node as a type, expressed using the {@code ModelType} enum. The string
   * value of this node must be convertible to a type.
   *
   * Throws a [FormatException] if no conversion is possible.
   */
  ModelType asType() => _value.asType();

  /**
   * Get the list of entries contained in this object. Property node types always contain exactly one entry (itself).
   * Lists will return an unmodifiable view of their contained list. Objects will return a list of properties corresponding
   * to the mappings within the object. Other types will return an empty list.
   */
  List<ModelNode> asList() => _value.asList();


  //---------------------------------------- [], is, has, getter methods

  /**
   * Get the child of this node with the given [indexOrName]. If [indexOrName] is an int and the node is undefined,
   * it will be initialized to be of type [ModelType.LIST]. If [indexOrName] is a string and the node is undefined,
   * it will be initialized to be of type [ModelType.OBJECT].
   *
   * When called on property values, the [indexOrName] must match the property name.
   *
   * Throws an [RangeError] if this node does not support getting a child with the given [indexOrName]
   */
  ModelNode operator [](indexOrName) {
    if (indexOrName is int) {
      if (_hasUndefinedValue()) {
        _assertNotProtected();
        _value = new _ListValue();
      }
      return _value[indexOrName];
    } else if (indexOrName is String) {
      if (_hasUndefinedValue()) {
        _assertNotProtected();
        _value = new _ObjectValue();
      }
      return _value[indexOrName];
    }
    throw new RangeError("Invalid index $indexOrName");
  }

  /**
   * Determine whether this node has a child with the given index or name. Property node types always contain exactly one
   * value with a key equal to the property name.
   */
  bool has(indexOrName) => _value.has(indexOrName);

  /**
   * Determine whether this node has a defined child with the given index or name. Property node types always contain
   * exactly one value with a key equal to the property name..
   */
  bool hasDefined(indexOrName) => _value.has(indexOrName) && _value[indexOrName].isDefined();

  /**
   * Determine whether this node is defined. Equivalent to the expression: `type != ModelType.UNDEFINED`
   */
  bool isDefined() => type != ModelType.UNDEFINED;

  bool _hasUndefinedValue() => _value == new _UndefinedValue();

  /**
   * Require the existence of a child of this node with the given index or name, returning the child. If no such
   * child exists, an exception is thrown.
   *
   * When called on property values, the name must match the property name.
   */
  ModelNode require(indexOrName) => _value.require(indexOrName);

  ModelType get type => _value.type;

  bool get failure => hasDefined(OUTCOME) && this[OUTCOME].asString() != SUCCESS;

  String get failureDescription => hasDefined(FAILURE_DESCRIPTION) ? this[FAILURE_DESCRIPTION].asString() : "No failure-description provided";

  /**
   * Get the set of keys contained in this object. Property node types always contain exactly one value with a key
   * equal to the property name. Other non-object types will return an empty set.
   */
  Iterable<String> get keys => _value.keys;


  //---------------------------------------- setter methods

  /**
   * Change this node's value to the given value. If [value] is a [ModelNode] or a list of [ModelNode]s, the value(s)
   * are copied.
   */
  void setValue(value) {
    if (value == null) {
      throw new ArgumentError("Value must not be null");
    }
    _assertNotProtected();
    if (value is int) {
      if (value < MIN_INT || value > MAX_INT) {
        _value = new _NumValue(value, ModelType.LONG);
      } else {
        _value = new _NumValue(value, ModelType.INT);
      }
    } else if (value is double) {
      _value = new _NumValue(value, ModelType.DOUBLE);
    } else if (value is bool) {
      _value = new _BooleanValue(value);
    } else if (value is String) {
      _value = new _StringValue(value);
    } else if (value is Property) {
      _value = new _PropertyValue(value);
    } else if (value is ModelType) {
      _value = new _ModelTypeValue(value);
    } else if (value is ModelNode) {
      _value = (value as ModelNode)._value.copy();
    } else if (value is List && !(value as List).isEmpty) {
      var elem = (value as List)[0];
      if (elem is int) {
        // we have a 'byte' array
        _value = new _BytesValue(value);
      } else if (elem is ModelNode) {
        // we have a list of ModelNode
        var newList = new List<ModelNode>();
        (value as List<ModelNode>).forEach((node) {
          if (node == null) {
            newList.add(new ModelNode());
          } else {
            newList.add(node.clone());
          }
        });
        _value = new _ListValue.from(newList);
      }
    }
  }

  /**
   * Change this node's value to a property with the given name and value.
   */
  void setProperty(String name, value) {
    if (name == null) {
      throw new ArgumentError("Name must not be null");
    }
    if (value == null) {
      throw new ArgumentError("Value must not be null");
    }
    _assertNotProtected();
    if (value is num || value is bool || value is String || value is Property) {
      var node = new ModelNode()..setValue(value);
      _value = new _PropertyValue.nameValue(name, node);
    } else if (value is ModelNode) {
      _value = new _PropertyValue.nameValue(name, value);
    }
    else if (value is List && !(value as List).isEmpty && (value as List)[0] is int) {
      // we have a 'byte' array
      var node = new ModelNode()..setValue(value);
      _value = new _PropertyValue.nameValue(name, node);
    }
  }

  /**
   * Change this node's value to an empty object.
   */
  void setEmptyObject() {
    _assertNotProtected();
    _value = new _ObjectValue();
  }

  /**
   * Change this node's value to an empty list.
   */
  void setEmptyList() {
    _assertNotProtected();
    _value = new _ListValue();
  }

  /**
   * Change this node's value to the given expression value.
   */
  void setExpression(String expression) {
    if (expression == null) {
      throw new ArgumentError("Value must not be null");
    }
    _assertNotProtected();
    _value = new _ExpressionValue(expression);
  }

  /**
   * Change this node's value to a property with the given name and expression value.
   */
  void setPropertyExpression(String name, String value) {
    _assertNotProtected();
    var node = new ModelNode()..setExpression(value);
    _value = new _PropertyValue.nameValue(name, node);
  }

  /**
   * Operator which combines the `[]` operator with the [setValue] method.
   * Shortcut for `node[indexOrName].setValue(value)`
   */
  void operator []=(indexOrName, value) => this[indexOrName].setValue(value);


  //---------------------------------------- add methods

  /**
   * Add a new node to the end of this node's value list. If the node is undefined, it will be initialized to be of
   * type [ModelType.LIST]. The new node is returned.
   */
  ModelNode add() {
    _assertNotProtected();
    if (_hasUndefinedValue()) {
      _value = new _ListValue();
    }
    return _value.add();
  }

  /**
   * Add a new node by calling [add] and call [assign] on it with the specified [value].
   * Convenience method for: `add().set(value)`
   */
  void addValue(value) => add().setValue(value);

  /**
   * Add a new node by calling [add] and then set the specified property on it.
   * Convenience method for: `add().setProperty(name, value)`
   */
  void addProperty(String name, value) => add().setProperty(name, value);

  /**
   * Add a new node by calling [add] and then set the specified [expression].
   * Convenience method for: `add().setExpression(expression);`
   */
  void addExpression(String expression) => add().setExpression(expression);

  /**
   * Add a node of type [ModelType.OBJECT] to the end of this node's value list and return it. If this node is
   * undefined, it will be initialized to be of type [ModelType.LIST].
   */
  ModelNode addEmptyObject() {
    var node = add();
    node.setEmptyObject();
    return node;
  }

  /**
   * Add a node of type [ModelType.LIST] to the end of this node's value list and return it. If this node is
   * undefined, it will be initialized to be of type [ModelType.LIST].
   */
  void addEmptyList() {
    var node = add();
    node.setEmptyList();
  }


  //---------------------------------------- misc methods

  /**
   * Clear this nodes value and change its type to [ModelType.UNDEFINED].
   */
  void clear() {
    _assertNotProtected();
    _value = new _UndefinedValue();
  }

  /**
   * Remove a child of this node, returning the child.  If no such child exists, an exception is thrown.
   */
  void remove(String name) => _value.remove(name);

  /**
   * Return a copy of this model node, with all system property expressions locally resolved. The caller must have
   * permission to access all of the system properties named in the node tree.
   */
  ModelNode resolve() => new ModelNode()..resolve();

  /**
   * Prevent further modifications to this node and its sub-nodes.  Note that copies
   * of this node made after this method call will not be protected.
   */
  void protect() {
    if (!_protect) {
      _protect = true;
      _value.protect();
    }
  }

  void _assertNotProtected() {
    if (_protect) {
      throw new StateError("ModelNode is protected against modifications");
    }
  }

  /**
   * Clones this model node.
   */
  ModelNode clone() => new ModelNode.from(_value.copy());


  //---------------------------------------- equal and hashCode

  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    }
    else if (other is ModelNode) {
      return _value == (other as ModelNode)._value;
    }
    return false;
  }

  int get hashCode => _value.hashCode;


  //---------------------------------------- string and format methods

  /**
   * Get a human-readable string representation of this model node, formatted nicely (possibly on multiple lines).
   */
  String toString() => _value.toString();

  String toJson() => _value.toJson();

  void _format(StringBuffer buffer, bool json, [int indent = 0]) => _value._format(buffer, json, indent);


  //---------------------------------------- external and base64 methods

  String toBase64() {
    var output = new _DataOutput();
    _writeExternal(output);
    return CryptoUtils.bytesToBase64(output.bytes);
  }

  static fromBase64(String encoded) {
    // Smilla was here!
    var node = new ModelNode();
    var decoded = CryptoUtils.base64StringToBytes(encoded);
    node._readExternal(new _DataInput(decoded));
    return node;
  }

  void _readExternal(_DataInput input) {
    _assertNotProtected();
    var type = new ModelType(new String.fromCharCode(input.readByte()));
    switch (type) {
      case ModelType.UNDEFINED:
        _value = new _UndefinedValue();
        break;
      case ModelType.BIG_DECIMAL:
      case ModelType.BIG_INTEGER:
        throw new UnsupportedError("Decoding / encoding ${ModelType.BIG_INTEGER} and ${ModelType.BIG_DECIMAL} is not supported yet!");
      case ModelType.BOOLEAN:
        _value = new _BooleanValue(input.readBool());
        break;
      case ModelType.BYTES:
        int length = input.readNum(ModelType.INT);
        _value = new _BytesValue(input.readBytes(length));
        break;
      case ModelType.DOUBLE:
        _value = new _NumValue(input.readNum(ModelType.DOUBLE), ModelType.DOUBLE);
        break;
      case ModelType.EXPRESSION:
        _value = new _ExpressionValue(input.readUtf());
        break;
      case ModelType.INT:
        _value = new _NumValue(input.readNum(ModelType.INT), ModelType.INT);
        break;
      case ModelType.LIST:
        int length = input.readNum(ModelType.INT);
        var list = new List<ModelNode>();
        for (int i = 0; i < length; i ++) {
          var node = new ModelNode();
          node._readExternal(input);
          list.add(node);
        }
        _value = new _ListValue.from(list);
        break;
      case ModelType.LONG:
        _value = new _NumValue(input.readNum(ModelType.INT), ModelType.INT);
        break;
      case ModelType.OBJECT:
        int length = input.readNum(ModelType.INT);
        var data = new LinkedHashMap<String, ModelNode>();
        for (int i = 0; i < length; i ++) {
          var key = input.readUtf();
          var value = new ModelNode();
          value._readExternal(input);
          data[key] = value;
        }
        _value = new _ObjectValue.from(data);
        break;
      case ModelType.PROPERTY:
        var name = input.readUtf();
        var value = new ModelNode();
        value._readExternal(input);
        _value = new _PropertyValue.nameValue(name, value);
        break;
      case ModelType.STRING:
        _value = new _StringValue(input.readUtf());
        break;
      case ModelType.TYPE:
        var t = new ModelType(new String.fromCharCode(input.readByte()));
        _value = new _ModelTypeValue(t);
        break;
      default:
        throw new StateError("Illegal type read: $type");
    }
  }

  void _writeExternal(_DataOutput output) {
    output.writeByte(type.id.codeUnitAt(0));
    _value._writeExternal(output);
  }
}
