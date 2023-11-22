import 'dart:io';

import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/scripts/config_scanner.dart';

String placeholder = "{{ content }}";

String layoutScanner(
    GlobalProvider globalProvider, String layout, String content) {
  String layoutPath =
      globalProvider.listLayout.firstWhere((l) => l.name == layout).path;
  String layoutContent = File(layoutPath).readAsStringSync();
  var config = configScanner(layoutContent);
  String contentGenerated = config.$2.replaceAll(placeholder, content);

  if (config.$1 != null) {
    return layoutScanner(globalProvider, config.$1!.layout, contentGenerated);
  }

  return contentGenerated;
}
