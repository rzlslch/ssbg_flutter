import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssbg_flutter/models/config_model.dart';
import 'package:ssbg_flutter/models/list_model.dart';
import 'package:ssbg_flutter/providers/editor_provider.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/providers/list_provider.dart';
import 'package:ssbg_flutter/providers/page_provider.dart';
import 'package:ssbg_flutter/scripts/action_addfile.dart';
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

    if (pageProvider.pageDir == "_post") {
      placeholder = "Title";
    } else if (pageProvider.pageDir == "_page") {
      placeholder = "File";
    } else {
      placeholder = "Template";
    }

    void inputTitleProcess(String value) {
      inputTitle.text = "";
      actionAddFile(globalProvider, pageProvider, listProvider, value);
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
