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

import "package:unittest/unittest.dart";
import "package:dmr/dmr.dart";

const num BIG_DOUBLE = 1.7976931348623157E300;

const num BIG_INT = 2147483600;

const num BIG_LONG = 924775000;

class ModelNodeTest {
  static void run() {
    group("ModelNodeTest", () {
      ModelNode node;
      setUp(() {
        node = new ModelNode();
        node["description"] = "A managable resource";
        node["type"] = ModelType.OBJECT;
        node["tail-comment-allowed"] = false;
        node["attributes"]["foo"] = "some description of foo";
        node["attributes"]["bar"] = "some description of bar";
        node["attributes"]["list"].addValue("value1");
        node["attributes"]["list"].addValue("value2");
        node["attributes"]["list"].addValue("value3");
        node["value-type"]["size"] = ModelType.INT;
        node["value-type"]["color"] = ModelType.STRING;
        node["bytes-value"] = [0, 55];
        node["double-value"] = 55.0;
        // TODO node["max-double-value"] = ...;
        node["int-value"] = 12;
        // TODO node["max-int-value"] = ...;
        node["long-value"] = 14;
        // TODO node["max-long-value"] = ...;
        node["property-value"].setProperty("property", ModelType.PROPERTY);
        node["expression-value"].setExpression("\$expression");
        node["true-value"] = true;
        node["false-value"] = false;
      });
      test("toString", () => print(node));
      test("toJson", () => print(node.toJson()));
      test("read/write", () {
        String encoded = node.toBase64();;
        var decoded = ModelNode.fromBase64(encoded);
        print("Decoded: $decoded");
      });
    });
  }
}

void main() {
  ModelNodeTest.run();
}
