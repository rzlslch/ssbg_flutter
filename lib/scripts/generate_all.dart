import 'dart:io';

import 'package:path/path.dart';
import 'package:ssbg_flutter/models/list_model.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/scripts/generator.dart';

Future<void> generateAll(GlobalProvider globalProvider) async {
  List<ListModel> listPage = globalProvider.listPage;
  String buildDir =
      globalProvider.config.entries.singleWhere((e) => e.key == "build").value;
  String dir = join(globalProvider.blogDir, buildDir);
  Directory dirBuild = Directory(dir);
  if (dirBuild.existsSync()) {
    dirBuild.createSync(recursive: true);
  }
  for (var c in dirBuild.listSync()) {
    c.deleteSync(recursive: true);
  }
  for (var c in listPage) {
    await generate(globalProvider, c, buildDir);
  }

  List<ListModel> listPost = globalProvider.listPost;
  for (var c in listPost) {
    await generate(globalProvider, c, buildDir);
  }
  String assetDir = "_assets";
  Directory dirAsset = Directory(join(globalProvider.blogDir, assetDir));
  for (var c in dirAsset.listSync(recursive: true)) {
    String pathChoose = c.path
        .replaceAll(dirAsset.path, join(globalProvider.blogDir, dirBuild.path));
    if (c is Directory) {
      Directory(pathChoose).createSync(recursive: true);
    } else if (c is File) {
      c.copySync(pathChoose);
    }
  }
}

Future<void> generate(
    GlobalProvider globalProvider, ListModel c, String buildDir) async {
  var generate = await generator(globalProvider, c);
  List chainLink = [];
  if (generate.$1.permalink != null) {
    chainLink = generate.$1.permalink!.split("/");
    String lastChainLink = chainLink[chainLink.length - 1];
    String link = "${lastChainLink == "" ? "index" : lastChainLink}.html";
    chainLink.removeAt(0);
    if (chainLink.length == 1) chainLink = [];
    chainLink.remove("");
    chainLink.add(link);
  } else {
    chainLink.add("${c.name}.html");
  }
  chainLink = [buildDir, ...chainLink];
  String dir = globalProvider.blogDir;
  for (var d in chainLink) {
    dir = join(dir, d);
  }
  File filePath = File(dir);
  if (!filePath.existsSync()) {
    filePath.createSync(recursive: true);
  }
  filePath.writeAsStringSync(generate.$2);
}
