import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssbg_flutter/models/list_model.dart';
import 'package:ssbg_flutter/providers/editor_provider.dart';
import 'package:ssbg_flutter/providers/list_provider.dart';
import 'package:ssbg_flutter/providers/page_provider.dart';
import 'package:ssbg_flutter/widgets/action_button.dart';
import 'package:ssbg_flutter/widgets/list_button.dart';

class ListScene extends StatelessWidget {
  const ListScene({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    EditorProvider editorProvider =
        Provider.of<EditorProvider>(context, listen: false);
    TextEditingController inputTitle = TextEditingController();
    PageProvider pageProvider =
        Provider.of<PageProvider>(context, listen: false);

    void inputTitleProcess(String value) {
      inputTitle.text = "";
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
                    decoration: const InputDecoration.collapsed(
                        hintText: 'Add New Title'),
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
                      editorProvider.setValue(file.readAsStringSync());
                      editorProvider.setPath(e.path);
                      editorProvider.setModel(ListModel(file));
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
