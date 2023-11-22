import 'dart:io';

import 'package:ssbg_flutter/models/list_model.dart';

import '../providers/global_provider.dart';

String cmdPrefix = "{%";
String cmdSuffix = "%}";

String htmlScanner(GlobalProvider globalProvider, String content) {
  List<ListModel> listInclude = globalProvider.listInclude;
  String processed = "";

  for (String c in content.split("\n")) {
    int idxPre = c.indexOf(cmdPrefix);
    int idxSuf = c.indexOf(cmdSuffix);
    if (idxPre > -1 && idxSuf > -1) {
      List cmdChain =
          c.substring(idxPre + cmdPrefix.length, idxSuf).trim().split(" ");
      if (cmdChain[0] == "include") {
        String fileContent =
            File(listInclude.firstWhere((x) => x.filename == cmdChain[1]).path)
                .readAsStringSync();
        c = fileContent;
      }
    }
    processed += "$c\n";
  }

  return processed;
}
