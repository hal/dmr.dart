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

class _ExpressionValue extends ModelValue {

  static const String TYPE_KEY = "EXPRESSION_VALUE";

  final String _expression;

  const _ExpressionValue(this._expression) : super(ModelType.EXPRESSION);

  String asString() => _expression;

  ModelValue resolve() => new _StringValue(_expression);

  bool operator ==(other) {
    if (identical(this, other)) {
      return true;
    } else if (other is _ExpressionValue) {
      return _expression == (other as _ExpressionValue)._expression;
    }
    return false;
  }

  int get hashCode => _expression.hashCode;

  void _format(StringBuffer buffer, bool json, [int indent = 0]) {
    if (json) {
      buffer..write("{")..write(TYPE_KEY)..write(":")..write(stringify(_expression))..write("}");
    } else {
      buffer..write("expression ")..write(stringify(_expression));
    }
  }

  void _writeExternal(_DataOutput output) => output.writeUtf(_expression);
}
