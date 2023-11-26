import 'dart:io';

import 'package:flutter/foundation.dart';

class ServerProvider with ChangeNotifier {
  HttpServer? _server;
  HttpServer? get server => _server;

  setServer(HttpServer server) {
    _server = server;
    notifyListeners();
  }
}
