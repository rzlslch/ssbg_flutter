import 'package:markdown/markdown.dart';
import 'package:ssbg_flutter/models/list_model.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/scripts/md_highlighter.dart';

String funcPrefix = "{%";
String funcSuffix = "%}";

String mdScanner(GlobalProvider globalProvider, String markdown) {
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
        strFunc.add({"type": "highlight", "$strLang": mdHighlight});
        startRecord = false;
        strLang = null;
        mdHighlight = "";
      }
      if (funcChain[0] == "post_url") {
        strFunc.add({"type": "post_url", "value": c});
      }
      ;
    } else {
      c += "\n";
    }
    if (startRecord) {
      mdHighlight += c;
    }
  }

  // this is for the highlight
  for (var c in strFunc) {
    String strType = c.entries.singleWhere((e) => e.key == "type").value;
    String strKey = c.entries.singleWhere((e) => e.key != "type").key;
    String strValue = c.entries.singleWhere((e) => e.key != "type").value;
    if (strType == 'highlight') {
      String hlHTML = mdHighlighter(strValue, strKey);
      String replaced =
          "$funcPrefix highlight $strKey $funcSuffix\n$strValue$funcPrefix endhighlight $funcSuffix";
      mdContent = mdContent.replaceAll(replaced, hlHTML);
    }
    if (strType == 'post_url') {
      mdContent = mdContent.replaceAll(
          strValue, postURL(globalProvider.listPost, strValue));
    }
  }

  String content = markdownToHtml(mdContent);

  return content;
}

String postURL(List<ListModel> post, String c) {
  int idxPre = c.indexOf(funcPrefix);
  int idxSuf = c.indexOf(funcSuffix);
  if (idxPre > -1 && idxSuf > -1) {
    List chain =
        c.substring(idxPre + funcPrefix.length, idxSuf).trim().split(" ");
    String replaced = "$funcPrefix ${chain[0]} ${chain[1]} $funcSuffix";
    c = c.replaceAll(replaced, "test");
    postURL(post, c);
  }
  return c;
}
