import 'package:flutter/widgets.dart';

class GlobalProvider with ChangeNotifier {
  String _blogDir = "";
  String get blogDir => _blogDir;

  void setDir(String dir) {
    _blogDir = dir;
    notifyListeners();
  }

  List _listInclude = [];
  List get listInclude => _listInclude;

  void addInclude(Map map) {
    _listInclude.add(map);
    notifyListeners();
  }

  void setInclude(List list) {
    _listInclude = list;
    notifyListeners();
  }

  List _listLayout = [];
  List get listLayout => _listLayout;

  void addLayout(Map map) {
    _listLayout.add(map);
    notifyListeners();
  }

  void setLayout(List list) {
    _listLayout = list;
    notifyListeners();
  }

  List _listPage = [];
  List get listPage => _listPage;

  void addPage(Map map) {
    _listPage.add(map);
    notifyListeners();
  }

  void setPage(List list) {
    _listPage = list;
    notifyListeners();
  }

  List _listPost = [];
  List get listPost => _listPost;

  void addPost(Map map) {
    _listPost.add(map);
    notifyListeners();
  }

  void setPost(List list) {
    _listPost = list;
    notifyListeners();
  }
}
