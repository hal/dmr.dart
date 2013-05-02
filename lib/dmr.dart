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

/**
Client Dart library to execute operations on the JBoss AS7 DMR API.
For an introduction to DMR please refer to the [JBoss Wiki](https://docs.jboss.org/author/display/AS7/Detyped+management+and+the+jboss-dmr+library).

## Usage
Here's a code snippet to read the version of the loacal server instance:

    var op = new ModelNode();
    op["operation"] = "read-attribute";
    op["address"].setEmptyList();
    op["name"] = "release-version";

    var version;
    var dmr = new Dmr("http://localhost:9000/management");
    dmr.send(op)
      .then((ModelNode node) => version = node["result"].asString())
      .catchError((exception) => print(exception));
 */

library dmr;

import "dart:async";
import "dart:collection";
import "dart:crypto";
//import "dart:fixnum";
import "dart:html";
import "dart:json";
import "dart:math";
import "dart:typed_data";
import 'package:meta/meta.dart';

part "src/Dmr.dart";
part "src/DmrException.dart";
part "src/ModelNode.dart";
part "src/ModelValue.dart";
part "src/ModelType.dart";
part "src/Property.dart";

part "src/BooleanValue.dart";
part "src/BytesValue.dart";
part "src/DataInput.dart";
part "src/DataOutput.dart";
part "src/ExpressionValue.dart";
part "src/ListValue.dart";
part "src/ModelTypeValue.dart";
part "src/NumValue.dart";
part "src/ObjectValue.dart";
part "src/PropertyValue.dart";
part "src/StringValue.dart";
part "src/UndefinedValue.dart";
