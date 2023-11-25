import 'dart:io';

import 'package:path/path.dart';
import 'package:ssbg_flutter/models/config_model.dart';
import 'package:ssbg_flutter/models/file_model.dart';
import 'package:ssbg_flutter/models/list_model.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/providers/list_provider.dart';
import 'package:ssbg_flutter/providers/page_provider.dart';

void actionAddFile(GlobalProvider glblPrvdr, PageProvider pgPrvdr,
    ListProvider lstPrvdr, String value) {
  if (value == "") return;

  String filename = "";
  String props = "";
  if (pgPrvdr.pageDir == "_post") {
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
  } else if (pgPrvdr.pageDir == "_page") {
    String titleParse =
        value.trim().replaceAll(RegExp(r'[^\w\s]+'), '').split(" ").join("-");
    props = ConfigModel(
            {"layout": "default", "title": value, "permalink": "/$titleParse"})
        .toString();
    filename = "$titleParse.md";
  } else {
    filename = "$value.html";
  }
  String targetFile = join(glblPrvdr.blogDir, pgPrvdr.pageDir, filename);
  File target = File(targetFile);
  if (target.existsSync()) return;
  target.createSync(recursive: true);
  target.writeAsStringSync(props);
  ListModel targetModel = ListModel(target);
  if (pgPrvdr.pageDir == "_post") glblPrvdr.addPost(targetModel);
  if (pgPrvdr.pageDir == "_page") glblPrvdr.addPage(targetModel);
  if (pgPrvdr.pageDir == "_include") glblPrvdr.addInclude(targetModel);
  if (pgPrvdr.pageDir == "_layout") glblPrvdr.addLayout(targetModel);
  FileModel fileModel = FileModel(filename: filename, path: target.path);
  lstPrvdr.addList(fileModel);
}

String timezoneCalc(Duration timezone) {
  String prefix = timezone.inHours < 0 ? "-" : "+";
  return "$prefix${timezone.inHours.toString().padRight(3, "0").padLeft(4, "0")}";
}
