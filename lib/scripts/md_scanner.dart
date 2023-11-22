import 'package:markdown/markdown.dart';
import 'package:ssbg_flutter/scripts/md_highlighter.dart';

String funcPrefix = "{%";
String funcSuffix = "%}";

String mdScanner(String markdown) {
  String mdContent = markdown;

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

  // this is for the highlight
  for (var c in strFunc) {
    var key = c.keys.firstOrNull;
    var value = c.values.firstOrNull;
    String hlHTML = mdHighlighter("$value", "$key");
    String replaced =
        "$funcPrefix highlight $key $funcSuffix\n$value$funcPrefix endhighlight $funcSuffix";
    mdContent = mdContent.replaceAll(replaced, hlHTML);
  }

  String content = markdownToHtml(mdContent);

  return content;
}
