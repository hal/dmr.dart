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

class _UndefinedValue extends ModelValue {

  static const _singleton = const _UndefinedValue._internal();

  factory _UndefinedValue() => _singleton;
  const _UndefinedValue._internal() : super(ModelType.UNDEFINED);

  int asNum([num onError(ModelValue value)]) => (?onError) ? onError(this) : super.asNum();

  bool asBool([bool onError(ModelValue value)]) => (?onError) ? onError(this) : super.asBool();

  String asString() => "undefined";

  bool operator ==(Object other) => identical(this, other);

  int get hashCode => 7113;

  void _format(StringBuffer buffer, bool json, [int indent = 0]) {
    json ? buffer.write("null") : super._format(buffer, json, indent);
  }
}
