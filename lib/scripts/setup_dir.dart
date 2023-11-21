import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:ssbg_flutter/models/list_model.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';

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
      List<ListModel> list = Directory(join(selectedDirectory, c.keys.first))
          .listSync()
          .map((e) => ListModel(e))
          .cast<ListModel>()
          .toList();
      c.values.first(list);
    }
  }
}
