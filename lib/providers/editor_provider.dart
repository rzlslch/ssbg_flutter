import 'package:flutter/widgets.dart';
import 'package:ssbg_flutter/models/config_model.dart';
import 'package:ssbg_flutter/models/list_model.dart';

class EditorProvider with ChangeNotifier {
  String _path = "";
  String get path => _path;

  void setPath(String path) {
    _path = path;
    notifyListeners();
  }

  String _value = "template";
  String get value => _value;

  void setValue(String value) {
    _value = value;
    notifyListeners();
  }

  ListModel _listModel = ListModel(null);
  ListModel get listModel => _listModel;

  void setModel(ListModel listModel) {
    _listModel = listModel;
    notifyListeners();
  }

  ConfigModel _configModel = ConfigModel({"layout": ""});
  ConfigModel get configModel => _configModel;

  void setConfig(ConfigModel configModel) {
    _configModel = configModel;
    notifyListeners();
  }
}
