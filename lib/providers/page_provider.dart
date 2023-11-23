import 'package:flutter/widgets.dart';

const String _pageTypeList = "list";
const String _pageTypeForm = "form";

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

  String _pageType = _pageTypeList;
  String get pageType => _pageType;

  void setPageList() {
    _pageType = _pageTypeList;
    notifyListeners();
  }

  void setPageForm() {
    _pageType = _pageTypeForm;
    notifyListeners();
  }

  bool _isContent = false;
  bool get isContent => _isContent;

  void setContent(bool isContent) {
    _isContent = isContent;
    notifyListeners();
  }
}
