import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:ssbg_flutter/models/list_model.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:yaml/yaml.dart';

Future<void> setupDir(GlobalProvider globalProvider) async {
  List<Map<String, Function>> folder = [
    {"_include": globalProvider.setInclude},
    {"_layout": globalProvider.setLayout},
    {"_page": globalProvider.setPage},
    {"_post": globalProvider.setPost},
  ];
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  globalProvider.setDir(selectedDirectory ?? "");
  if (selectedDirectory != null) {
    for (var c in folder) {
      String pathDir = join(selectedDirectory, c.keys.first);
      Directory dir = Directory(pathDir);

      if (dir.existsSync()) {
        List<ListModel> list = Directory(join(selectedDirectory, c.keys.first))
            .listSync()
            .map((e) => ListModel(e))
            .cast<ListModel>()
            .toList();
        c.values.first(list);
      } else {
        dir.createSync(recursive: true);
      }
    }

    String configPathFile = join(selectedDirectory, "_config", "_config.yaml");
    File configFile = File(configPathFile);
    if (!configFile.existsSync()) {
      configFile.createSync(recursive: true);
      configFile.writeAsStringSync(
          "title: title-example\nurl: url.example.io\nemail: user@email.com\nbuild: public");
    }
    String configContent = configFile.readAsStringSync();
    YamlMap configYaml = loadYaml(configContent);
    globalProvider.setConfig(configYaml.cast());
  }
}
