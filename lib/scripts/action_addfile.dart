import 'dart:io';

import 'package:path/path.dart';
import 'package:ssbg_flutter/models/config_model.dart';
import 'package:ssbg_flutter/models/file_model.dart';
import 'package:ssbg_flutter/models/list_model.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/providers/list_provider.dart';
import 'package:ssbg_flutter/providers/page_provider.dart';

void actionAddFile(GlobalProvider globalProvider, PageProvider pageProvider,
    ListProvider listProvider, String value) {
  if (value == "") return;
  Map<String, Function> x = {
    "_post": (ListModel list) => globalProvider.addPost,
    "_page": (ListModel list) => globalProvider.addPage,
    "_include": (ListModel list) => globalProvider.addInclude,
    "_layout": (ListModel list) => globalProvider.addLayout,
  };

  String filename = "";
  String props = "";
  if (pageProvider.pageDir == "_post") {
    DateTime dateNow = DateTime.now();
    String dateTimeZone = timezoneCalc(dateNow.timeZoneOffset);
    String dateParse = "${dateNow.year}-${dateNow.month}-${dateNow.day}";
    String titleParse =
        value.trim().replaceAll(RegExp(r'[^\w\s]+'), '').split(" ").join("-");
    String filenameTemplate = "$dateParse-$titleParse";
    props = ConfigModel({
      "layout": "post",
      "title": value,
      "permalink": "/$titleParse",
      "date":
          "$dateParse ${dateNow.hour}:${dateNow.minute.toString().padLeft(2, "0")} $dateTimeZone",
      "categories": "post",
      "comments": "true"
    }).toString();
    filename = "$filenameTemplate.md";
  } else if (pageProvider.pageDir == "_page") {
    String titleParse =
        value.trim().replaceAll(RegExp(r'[^\w\s]+'), '').split(" ").join("-");
    props = ConfigModel(
            {"layout": "default", "title": value, "permalink": "/$titleParse"})
        .toString();
    filename = "$titleParse.md";
  } else {
    filename = "$value.html";
  }
  String targetFile =
      join(globalProvider.blogDir, pageProvider.pageDir, filename);
  File target = File(targetFile);
  if (target.existsSync()) return;
  target.createSync(recursive: true);
  target.writeAsStringSync(props);
  x.entries
      .singleWhere((e) => e.key == pageProvider.pageDir)
      .value(ListModel(target));
  FileModel fileModel = FileModel(filename: filename, path: target.path);
  listProvider.addList(fileModel);
}

String timezoneCalc(Duration timezone) {
  String prefix = timezone.inHours < 0 ? "-" : "+";
  return "$prefix${timezone.inHours.toString().padRight(3, "0").padLeft(4, "0")}";
}
