library hop_runner;

import "package:hop/hop.dart";
import "package:hop/hop_tasks.dart";

void main() {
  var docTask = createDartDocTask(["lib/dmr.dart"], linkApi: true, excludeLibs: ["meta", "metadata"]);
  addTask("docs", docTask);
  runHop();
}