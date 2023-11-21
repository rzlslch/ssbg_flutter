import 'dart:io';

class ListModel {
  String name = "";
  String path = "";
  String filename = "";

  ListModel(FileSystemEntity fse) {
    String filename = fse.path.replaceAll(fse.parent.path, "").substring(1);
    String name = filename.split(".")[0];
    String path = fse.path;
    this.filename = filename;
    this.name = name;
    this.path = path;
  }
}
