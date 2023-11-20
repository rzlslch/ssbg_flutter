import 'package:flutter/widgets.dart';
import 'package:ssbg_flutter/models/file_model.dart';

class ListProvider with ChangeNotifier {
  String _dir = "";
  String get dir => _dir;

  void setDir(String dir) {
    _dir = dir;
    notifyListeners();
  }

  List<FileModel> _list = <FileModel>[];
  List<FileModel> get list => _list;

  void setList(List<FileModel> list) {
    _list = list.reversed.cast<FileModel>().toList();
    notifyListeners();
  }

  void addList(FileModel map) {
    _list.add(map);
    _list = list.reversed.toList();
    notifyListeners();
  }
}
