import 'package:ssbg_flutter/scripts/md_highlighter.dart';

String propPrefix = "---\n";
String propSuffix = "\n---\n";
String funcPrefix = "{%";
String funcSuffix = "%}";

String mdScanner(String markdown) {
  int propPrefixIndex = markdown.indexOf(propPrefix);
  int propSuffixIndex = markdown.lastIndexOf(propSuffix);
  String propString = "";
  String mdContent = markdown;

  if (propPrefixIndex > -1 && propSuffixIndex > -1) {
    propString = markdown.substring(
        propPrefixIndex + propPrefix.length, propSuffixIndex);
    mdContent = markdown.replaceRange(
        propPrefixIndex, propSuffixIndex + propSuffix.length, "");
  }

  Map<String, String> props = {};

  for (var c in propString.split("\n")) {
    List<String> propC = c.split(":");
    String propKey = propC[0].toString().trim();
    propC.removeAt(0);
    String propValue = propC.join(":").trim();
    props[propKey] = propValue;
  }

  String mdHighlight = "";
  bool startRecord = false;
  List<Map<String, String>> strFunc = <Map<String, String>>[];
  String? strLang;

  for (var c in mdContent.split("\n")) {
    int mdPrefIdx = c.indexOf(funcPrefix);
    int mdSuffIdx = c.indexOf(funcSuffix);
    if (mdPrefIdx > -1 && mdSuffIdx > -1) {
      String funcCmd = c.substring(mdPrefIdx + funcPrefix.length, mdSuffIdx);
      List<String> funcChain = funcCmd.trim().split(" ");
      if (funcChain[0] == "highlight") {
        startRecord = true;
        strLang = funcChain[1];
        c = "";
      }
      if (funcChain[0] == "endhighlight") {
        strFunc.add({"$strLang": mdHighlight});
        startRecord = false;
        strLang = null;
        mdHighlight = "";
      }
    } else {
      c += "\n";
    }
    if (startRecord) {
      mdHighlight += c;
    }
  }

  for (var c in strFunc) {
    var key = c.keys.firstOrNull;
    var value = c.values.firstOrNull;
    String hlHTML = mdHighlighter("$value", "$key");
    String replaced =
        "$funcPrefix highlight $key $funcSuffix\n$value$funcPrefix endhighlight $funcSuffix";
    markdown = markdown.replaceAll(replaced, hlHTML);
  }

  return markdown;
}
