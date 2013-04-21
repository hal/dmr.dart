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
 * Class to send requests against the management interface of a running JBoss 
 * instance. An instance of this class is connected to a management endpoint 
 * and can be reused for any number requests. 
 * 
 * To send a request use the [send] method and provide a [ModelNode] which 
 * must contain the operation together with all necessary attributes. See
 * [the JBoss wiki](https://docs.jboss.org/author/display/AS72/Management+API+reference) for
 * more infos.
 */
class Dmr {

  final String managementUrl;

  const Dmr(this.managementUrl);

  Future<ModelNode> send(ModelNode operation) {
    var completer = new Completer<ModelNode>();
    var httpRequest = new HttpRequest();

    httpRequest.open("POST", managementUrl);
    httpRequest.setRequestHeader("Content-type","application/dmr-encoded");
    httpRequest.setRequestHeader("Accept","application/dmr-encoded");
    httpRequest.withCredentials = true;
    httpRequest.onLoadEnd.listen((e) {
      if (httpRequest.status == 200) {
        try {
          var node = ModelNode.fromBase64(httpRequest.responseText);
          completer.complete(node);
        } catch (e) {
          completer.completeError(new DmrException("Error parsing DMR response: $e"));
        }
      } else if (httpRequest.status == 401) {
        completer.completeError(new DmrException("Authentication required."));
      } else if (httpRequest.status == 503) {
        completer.completeError(new DmrException("Service temporarily unavailable. Is the server is still booting?"));
      } else if (httpRequest.status == 0) {
        completer.completeError(new DmrException("Unable to connect. Server running?"));
      } else {
      completer.completeError(new DmrException("Unknown error: ${httpRequest.status} - ${httpRequest.statusText}"));
      }
    });
    httpRequest.send(operation.toBase64());

    return completer.future;
  }
}
