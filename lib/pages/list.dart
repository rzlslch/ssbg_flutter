import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssbg_flutter/providers/editor_provider.dart';
import 'package:ssbg_flutter/providers/list_provider.dart';
import 'package:ssbg_flutter/providers/page_provider.dart';
import 'package:ssbg_flutter/widgets/header_button.dart';

import '../widgets/action_button.dart';
import '../widgets/list_button.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    EditorProvider editorProvider =
        Provider.of<EditorProvider>(context, listen: false);
    TextEditingController inputTitle = TextEditingController();

    void inputTitleProcess(String value) {
      inputTitle.text = "";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderButton(),
        const SizedBox(
          height: 10,
        ),
        Consumer<ListProvider>(
          builder: (context, listProvider, _) => Row(
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
                decoration:
                    const InputDecoration.collapsed(hintText: 'Add New Title'),
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (value) => inputTitleProcess(value),
              )))
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: Consumer<ListProvider>(
          builder: (context, listProvider, _) => ListView(
            children: listProvider.list
                .map((e) => Consumer<PageProvider>(
                      builder: (context, pageProvider, child) => ListButton(
                        title: e.filename,
                        function: () {
                          final File file = File(e.path);
                          editorProvider.setValue(file.readAsStringSync());
                          editorProvider.setPath(e.path);
                          pageProvider.update(2);
                        },
                      ),
                    ))
                .toList(),
          ),
        ))
      ],
    );
  }
}
