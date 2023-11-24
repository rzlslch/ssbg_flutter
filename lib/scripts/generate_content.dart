import 'dart:io';

import 'package:path/path.dart';
import 'package:ssbg_flutter/models/config_model.dart';
import 'package:ssbg_flutter/models/list_model.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/scripts/generator.dart';

Future<void> generateContent(GlobalProvider globalProvider, ListModel listModel,
    ConfigModel configModel) async {
  String buildDir =
      globalProvider.config.entries.singleWhere((e) => e.key == "build").value;
  String filePath =
      join(globalProvider.blogDir, buildDir, configModel.url.split("/")[1]);
  String content = (await generator(globalProvider, listModel)).$2;
  File file = File(filePath);
  if (file.existsSync()) {
    file.createSync(recursive: true);
  }
  file.writeAsStringSync(content);
}
