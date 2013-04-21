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

abstract class ModelValue {

  final ModelType type;

  const ModelValue(this.type);

  num asNum([num onError(ModelValue value)]) {
    throw new UnsupportedError("asNum() is not supported in $runtimeType");
  }

  bool asBool([bool onError(ModelValue value)]) {
    throw new UnsupportedError("asBool() is not supported in $runtimeType");
  }

  String asString();

  List<int> asBytes() {
    throw new UnsupportedError("asBytes() is not supported in $runtimeType");
  }

  Property asProperty() {
    throw new UnsupportedError("asProperty() is not supported in $runtimeType");
  }

  List<Property> asPropertyList() {
    throw new UnsupportedError("asPropertyList() is not supported in $runtimeType");
  }

  ModelNode asObject() {
    throw new UnsupportedError("asObject() is not supported in $runtimeType");
  }

  List<ModelNode> asList() {
    throw new UnsupportedError("asList() is not supported in $runtimeType");
  }

  ModelType asType() {
    throw new UnsupportedError("asType() is not supported in $runtimeType");
  }

  ModelNode operator [](indexOrKey) {
    throw new RangeError.value(indexOrKey);
  }

  bool has(indexOrKey) => false;

  ModelNode require(indexOrKey) {
    throw new RangeError.value(indexOrKey);
  }

  ModelNode add() {
    throw new UnsupportedError("add() is not supported in $runtimeType");
  }

  void remove(String key) {
    throw new UnsupportedError("remove() is not supported in $runtimeType");
  }

  Iterable<String> get keys {
    throw new UnsupportedError("keys() is not supported in $runtimeType");
  }

  void protect() {
    // nop
  }

  ModelValue copy() => this;

  ModelValue resolve() => copy();

  bool operator ==(other);

  int get hashCode;

  void _indent(StringBuffer buffer, int count) => buffer.writeAll(new List.filled(count, "    "));

  void _format(StringBuffer buffer, bool json, [int indent = 0]) => buffer.write(asString());

  String toString() {
    final StringBuffer buffer = new StringBuffer();
    _format(buffer, false);
    return buffer.toString();
  }

  String toJson() {
    final StringBuffer buffer = new StringBuffer();
    _format(buffer, true);
    return buffer.toString();
  }

  void _writeExternal(_DataOutput output) {
    // nothing by default
  }
}

