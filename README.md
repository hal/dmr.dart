# DMR.dart

Client Dart library to execute operations on the JBoss AS7 DMR API.
For an introduction to DMR please refer to the [JBoss Wiki](https://docs.jboss.org/author/display/AS7/Detyped+management+and+the+jboss-dmr+library).

## Usage
For a basic example see [`example/dmr_example.dart`](example/dmr_example.dart). To get an idea how the code looks like
here's a code snippet to read the version of the loacal server instance:

```javascript
var op = new ModelNode();
op["operation"] = "read-attribute";
op["address"].setEmptyList();
op["name"] = "release-version";

var version;
var dmr = new Dmr("http://localhost:9000/management");
dmr.send(op)
  .then((ModelNode node) => version = node["result"].asString())
  .catchError((exception) => print(exception));

```

## Requirements
For the example to work, you need a running JBoss AS instance which accepts CORS requests. You can build one 
by cloning the [AS8 CORS branch](https://github.com/hpehl/jboss-as/tree/cors). If you have trouble with CORS,
take a look at this [blog post](http://hpehl.info/independent-jboss-admin-console.html).

## Known Issues
- Due to a [bug](https://code.google.com/p/dart/issues/detail?id=3247) in Dart, DMR.dart currently works only in Dartium.
- Big integer and double values are making problems. This will be addressed once the `fixnum` package is officially available.
