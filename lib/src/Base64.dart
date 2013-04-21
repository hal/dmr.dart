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

class _Base64 {

  static const List<String> _encodingTable = const ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'];

  /**
   * Base64 transfer encoding for MIME (RFC 2045)
   */
  static String encode(List<int> data) {
    List<String> characters = new List<String>();
    int i;
    for (i = 0; i + 3 <= data.length; i += 3) {
      int value = 0;
      value |= data[i + 2];
      value |= data[i + 1] << 8;
      value |= data[i] << 16;
      for (int j = 0; j < 4; j++) {
        int index = (value >> ((3 - j) * 6)) & ((1 << 6) - 1);
        characters.add(_encodingTable[index]);
      }
    }
    // Remainders.
    if (i + 2 == data.length) {
      int value = 0;
      value |= data[i + 1] << 8;
      value |= data[i] << 16;
      for (int j = 0; j < 3; j++) {
        int index = (value >> ((3 - j) * 6)) & ((1 << 6) - 1);
        characters.add(_encodingTable[index]);
      }
      characters.add("=");
    } else if (i + 1 == data.length) {
      int value = 0;
      value |= data[i] << 16;
      for (int j = 0; j < 2; j++) {
        int index = (value >> ((3 - j) * 6)) & ((1 << 6) - 1);
        characters.add(_encodingTable[index]);
      }
      characters.add("=");
      characters.add("=");
    }
    StringBuffer output = new StringBuffer();
    for (i = 0; i < characters.length; i++) {
      if (i > 0 && i % 76 == 0) {
        output.write("\r\n");
      }
      output.write(characters[i]);
    }
    return output.toString();
  }


  /**
   * Base64 transfer decoding for MIME (RFC 2045).
   */
  static List<int> decode(String data) {
    List<int> result = new List<int>();
    int padCount = 0;
    int charCount = 0;
    int value = 0;
    for (int i = 0; i < data.length; i++) {
      int char = data.codeUnitAt(i);
      if (65 <= char && char <= 90) {
        // "A" - "Z".
        value = (value << 6) | char - 65;
        charCount++;
      } else if (97 <= char && char <= 122) {
        // "a" - "z".
        value = (value << 6) | char - 97 + 26;
        charCount++;
      } else if (48 <= char && char <= 57) {
        // "0" - "9".
        value = (value << 6) | char - 48 + 52;
        charCount++;
      } else if (char == 43) {
        // "+".
        value = (value << 6) | 62;
        charCount++;
      } else if (char == 47) {
        // "/".
        value = (value << 6) | 63;
        charCount++;
      } else if (char == 61) {
        // "=".
        value = (value << 6);
        charCount++;
        padCount++;
      }
      if (charCount == 4) {
        result.add((value & 0xFF0000) >> 16);
        if (padCount < 2) {
          result.add((value & 0xFF00) >> 8);
        }
        if (padCount == 0) {
          result.add(value & 0xFF);
        }
        charCount = 0;
        value = 0;
      }
    }
    return result;
  }
}
