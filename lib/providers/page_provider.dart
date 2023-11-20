import 'package:flutter/widgets.dart';

class PageProvider with ChangeNotifier {
  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  void update(int pageIndex) {
    _pageIndex = pageIndex;
    notifyListeners();
  }

  void back() {
    if (_pageIndex > 0) {
      _pageIndex--;
    }
    notifyListeners();
  }
}
