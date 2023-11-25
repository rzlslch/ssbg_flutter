import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:http_server/http_server.dart';
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

    Directory assetDir = Directory(join(selectedDirectory, "_assets"));
    if (!assetDir.existsSync()) {
      assetDir.createSync(recursive: true);
    }

    Map<String, String> loadConfig = globalProvider.config;
    String buildDir =
        loadConfig.entries.singleWhere((e) => e.key == "build").value;
    VirtualDirectory staticFile =
        VirtualDirectory(join(globalProvider.blogDir, buildDir));
    staticFile.allowDirectoryListing = true;
    staticFile.directoryHandler = (Directory dir, HttpRequest request) {
      var indexUri = Uri.file(dir.path).resolve('index.html');
      staticFile.serveFile(File(indexUri.toFilePath()), request);
    };

    staticFile.jailRoot = true;
    HttpServer server = await HttpServer.bind("127.0.0.1", 8080);

    server.listen((HttpRequest request) {
      List<String> chainLink = request.uri.path.split("/");
      String path = join(globalProvider.blogDir, buildDir);
      for (var c in chainLink) {
        path = join(path, c);
      }
      File file = File(path);
      if (file.existsSync()) {
        staticFile.serveFile(file, request);
        return;
      }

      String pathIndex = join(path, "index.html");
      File fileIndex = File(pathIndex);
      if (fileIndex.existsSync()) {
        staticFile.serveFile(fileIndex, request);
        return;
      }

      String pathContent = "$path.html";
      File fileContent = File(pathContent);
      if (fileContent.existsSync()) {
        staticFile.serveFile(fileContent, request);
        return;
      }

      request.response.write("404");
      request.response.close();
    });
  }
}
