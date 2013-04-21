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

class ModelType {

  static const BIG_DECIMAL = const ModelType._internal("d", "BIG_DECIMAL");
  static const BIG_INTEGER = const ModelType._internal("i", "BIG_INTEGER");
  static const BOOLEAN = const ModelType._internal("Z", "BOOLEAN");
  static const BYTES = const ModelType._internal("b", "BYTES");
  static const DOUBLE = const ModelType._internal("D", "DOUBLE");
  static const EXPRESSION = const ModelType._internal("e", "EXPRESSION");
  static const INT = const ModelType._internal("I", "INT");
  static const LIST = const ModelType._internal("l", "LIST");
  static const LONG = const ModelType._internal("J", "LONG");
  static const OBJECT = const ModelType._internal("o", "OBJECT");
  static const PROPERTY = const ModelType._internal("p", "PROPERTY");
  static const STRING = const ModelType._internal("s", "STRING"); // also S for long string
  static const TYPE = const ModelType._internal("t", "TYPE");
  static const UNDEFINED = const ModelType._internal("u", "UNDEFINED");

  final String _id;
  final String _name;

  const ModelType._internal(this._id, this._name);

  factory ModelType(String type) {
    switch (type) {
      case "d": return BIG_DECIMAL;
      case "i": return BIG_INTEGER;
      case "Z": return BOOLEAN;
      case "b": return BYTES;
      case "D": return DOUBLE;
      case "e": return EXPRESSION;
      case "I": return INT;
      case "l": return LIST;
      case "J": return LONG;
      case "o": return OBJECT;
      case "p": return PROPERTY;
      case "s": return STRING;
      case "t": return TYPE;
      default: return UNDEFINED;
    }
  }

  String toString() => _name;

  String get id => _id;
}
