import 'package:ssbg_flutter/models/list_model.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/scripts/config_scanner.dart';

String placeholder = "{{ content }}";

String layoutScanner(
    GlobalProvider globalProvider, String layout, String content) {
  ListModel listModel =
      globalProvider.listLayout.firstWhere((l) => l.name == layout);
  var config = configScanner(listModel);
  String contentGenerated = config.$2.replaceAll(placeholder, content);

  if (config.$1 != null) {
    return layoutScanner(globalProvider, config.$1!.layout, contentGenerated);
  }

  return contentGenerated;
}
