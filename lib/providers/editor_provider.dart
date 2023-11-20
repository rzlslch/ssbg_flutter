import 'package:flutter/widgets.dart';

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
}
