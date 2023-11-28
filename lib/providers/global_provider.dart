import 'package:flutter/widgets.dart';
import 'package:ssbg_flutter/models/list_model.dart';

class GlobalProvider with ChangeNotifier {
  String _blogDir = "";
  String get blogDir => _blogDir;

  void setDir(String dir) {
    _blogDir = dir;
    notifyListeners();
  }

  Map<String, String> _config = {};
  Map<String, String> get config => _config;

  void setConfig(Map<String, String> config) {
    _config = config;
    notifyListeners();
  }

  List<ListModel> _listInclude = <ListModel>[];
  List<ListModel> get listInclude => _listInclude;

  void addInclude(ListModel listModel) {
    _listInclude.add(listModel);
    notifyListeners();
  }

  void setInclude(List<ListModel> list) {
    _listInclude = list;
    notifyListeners();
  }

  List<ListModel> _listLayout = <ListModel>[];
  List<ListModel> get listLayout => _listLayout;

  void addLayout(ListModel listModel) {
    _listLayout.add(listModel);
    notifyListeners();
  }

  void setLayout(List<ListModel> list) {
    _listLayout = list;
    notifyListeners();
  }

  List<ListModel> _listPage = <ListModel>[];
  List<ListModel> get listPage => _listPage;

  void addPage(ListModel listModel) {
    _listPage.add(listModel);
    notifyListeners();
  }

  void setPage(List<ListModel> list) {
    _listPage = list;
    notifyListeners();
  }

  List<ListModel> _listPost = <ListModel>[];
  List<ListModel> get listPost => _listPost;

  void addPost(ListModel listModel) {
    _listPost.add(listModel);
    _listPost.sort((b, a) => a.filename.compareTo(b.filename));
    notifyListeners();
  }

  void setPost(List<ListModel> list) {
    _listPost = list;
    _listPost.sort((b, a) => a.filename.compareTo(b.filename));
    notifyListeners();
  }
}
