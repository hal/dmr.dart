import "dart:html";
import "package:dmr/dmr.dart";

void main() {
  InputElement version = query("#version");
  InputElement input = query("#managementUrl");

  query("#showVersion").onClick.listen((e) {
    var op = new ModelNode();
    op["operation"] = "read-attribute";
    op["address"].setEmptyList();
    op["name"] = "release-version";

    var dmr = new Dmr(input.value);
    dmr.send(op)
      .then((ModelNode node) {
        version.classes.remove("error");
        version.value = node["result"].asString();
      })
      .catchError((exception) {
        version.classes.add("error");
        version.value = exception.toString();
    });
  });
}