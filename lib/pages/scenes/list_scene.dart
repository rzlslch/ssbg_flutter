import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:ssbg_flutter/models/config_model.dart';
import 'package:ssbg_flutter/models/file_model.dart';
import 'package:ssbg_flutter/models/list_model.dart';
import 'package:ssbg_flutter/providers/editor_provider.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/providers/list_provider.dart';
import 'package:ssbg_flutter/providers/page_provider.dart';
import 'package:ssbg_flutter/scripts/config_scanner.dart';
import 'package:ssbg_flutter/widgets/action_button.dart';
import 'package:ssbg_flutter/widgets/list_button.dart';

class ListScene extends StatelessWidget {
  const ListScene({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String placeholder = "";
    EditorProvider editorProvider =
        Provider.of<EditorProvider>(context, listen: false);
    PageProvider pageProvider =
        Provider.of<PageProvider>(context, listen: false);
    GlobalProvider globalProvider =
        Provider.of<GlobalProvider>(context, listen: false);
    ListProvider listProvider =
        Provider.of<ListProvider>(context, listen: false);
    TextEditingController inputTitle = TextEditingController();

    String timezoneCalc(Duration timezone) {
      String prefix = timezone.inHours < 0 ? "-" : "+";
      return "$prefix${timezone.inHours.toString().padRight(3, "0").padLeft(4, "0")}";
    }

    if (pageProvider.pageDir == "_post") {
      placeholder = "Title";
    } else if (pageProvider.pageDir == "_page") {
      placeholder = "File";
    } else {
      placeholder = "Template";
    }

    void inputTitleProcess(String value) {
      inputTitle.text = "";
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
        String titleParse = value
            .trim()
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .split(" ")
            .join("-");
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
        String titleParse = value
            .trim()
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .split(" ")
            .join("-");
        props = ConfigModel({
          "layout": "default",
          "title": value,
          "permalink": "/$titleParse"
        }).toString();
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

    return Expanded(
        child: Column(
      children: [
        Row(
          children: [
            ActionButton(
                function: () {
                  inputTitleProcess(inputTitle.text);
                },
                text: "ADD",
                icon: Icons.add),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Material(
                child: TextFormField(
                    controller: inputTitle,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Add New $placeholder'),
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) => inputTitleProcess(value)),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: Consumer<ListProvider>(
          builder: (context, listProvider, _) => ListView(
            children: listProvider.list
                .map((e) => ListButton(
                    title: e.filename,
                    function: () {
                      final File file = File(e.path);
                      ListModel listModel = ListModel(file);
                      ConfigModel? configModel = configScanner(listModel).$1;
                      editorProvider.setValue(file.readAsStringSync());
                      editorProvider.setPath(e.path);
                      editorProvider.setModel(listModel);
                      editorProvider.setConfig(
                          configModel ?? ConfigModel({"layout": ""}));
                      pageProvider.update(2);
                      if (listProvider.dir == '_post' ||
                          listProvider.dir == '_page') {
                        pageProvider.setContent(true);
                      } else {
                        pageProvider.setContent(false);
                      }
                    }))
                .toList(),
          ),
        ))
      ],
    ));
  }
}
