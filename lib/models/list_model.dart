import 'dart:io';

class ListModel {
  String name = "";
  String path = "";
  String filename = "";
  String created = "";

  ListModel(FileSystemEntity? fse) {
    String? filename = fse?.path.replaceAll(fse.parent.path, "").substring(1);
    String? name = filename?.split(".")[0];
    String? path = fse?.path;
    String? created = fse?.statSync().changed.toString();
    this.filename = filename ?? "";
    this.name = name ?? "";
    this.path = path ?? "";
    this.created = created ?? "";
  }
}
