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

import "package:dmr/dmr.dart";
import "package:unittest/unittest.dart";
import "package:unittest/html_enhanced_config.dart";

class NumValueTest {
  static void run() {
    group("NumValueTest", () {
      test("asBytes()", () {
        var node = new ModelNode();

        node["int"]["value"] = 2342;
        node["int"]["bytes"] = [0, 0, 9, 38];
        expect(node["int"]["value"].asBytes(), orderedEquals(node["int"]["bytes"].asBytes()));

        node["long"]["value"] = 3904985688296939292;
        node["long"]["bytes"] = [54, 49, 75, -53, 67, -20, 95, 28];
        expect(node["long"]["value"].asBytes(), orderedEquals(node["long"]["bytes"].asBytes()));
      });
    });
  }
}

void main() {
  NumValueTest.run();
}
