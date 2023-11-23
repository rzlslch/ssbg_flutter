import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_toolbar/markdown_toolbar.dart';
import 'package:provider/provider.dart';
import 'package:ssbg_flutter/providers/editor_provider.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/providers/page_provider.dart';
import 'package:ssbg_flutter/scripts/generator.dart';
import 'package:ssbg_flutter/widgets/action_button.dart';
import 'package:ssbg_flutter/widgets/header_button.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final EditorProvider editorProvider =
        Provider.of<EditorProvider>(context, listen: false);
    TextEditingController editorController =
        TextEditingController(text: editorProvider.value);
    GlobalProvider globalProvider =
        Provider.of<GlobalProvider>(context, listen: false);
    PageProvider pageProvider =
        Provider.of<PageProvider>(context, listen: false);
    Timer? debounce;
    final FocusNode focusNode = FocusNode();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderButton(),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            ActionButton(
                function: () {},
                text: "GENERATE ALL",
                icon: Icons.replay_rounded),
            const SizedBox(
              width: 10,
            ),
            pageProvider.isContent
                ? ActionButton(
                    function: () {
                      generator(globalProvider, editorController.text);
                    },
                    text: "GENERATE",
                    icon: Icons.replay_rounded)
                : Container(),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: Material(
                child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 0, top: 0, left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdownToolbar(
                  useIncludedTextField: false,
                  controller: editorController,
                  focusNode: focusNode,
                  width: 32,
                ),
                const Divider(),
                Actions(
                  actions: {InsertTabIntent: InsertTabAction()},
                  child: Expanded(
                    child: Shortcuts(
                      shortcuts: {
                        LogicalKeySet(LogicalKeyboardKey.tab):
                            InsertTabIntent(2, editorController)
                      },
                      child: TextFormField(
                        controller: editorController,
                        focusNode: focusNode,
                        maxLines: null,
                        expands: true,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.1,
                        ),
                        decoration:
                            const InputDecoration.collapsed(hintText: ""),
                        onChanged: (value) {
                          if (debounce?.isActive ?? false) debounce?.cancel();
                          debounce =
                              Timer(const Duration(milliseconds: 500), () {
                            final File file = File(editorProvider.path);
                            file.writeAsString(value);
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        )))
      ],
    );
  }
}

class InsertTabIntent extends Intent {
  const InsertTabIntent(this.numSpaces, this.textController);
  final int numSpaces;
  final TextEditingController textController;
}

class InsertTabAction extends Action {
  @override
  Object invoke(covariant Intent intent) {
    if (intent is InsertTabIntent) {
      final oldValue = intent.textController.value;
      final newComposing = TextRange.collapsed(oldValue.composing.start);
      final newSelection = TextSelection.collapsed(
          offset: oldValue.selection.start + intent.numSpaces);

      final newText = StringBuffer(oldValue.selection.isValid
          ? oldValue.selection.textBefore(oldValue.text)
          : oldValue.text);
      for (var i = 0; i < intent.numSpaces; i++) {
        newText.write(' ');
      }
      newText.write(oldValue.selection.isValid
          ? oldValue.selection.textAfter(oldValue.text)
          : '');
      intent.textController.value = intent.textController.value.copyWith(
        composing: newComposing,
        text: newText.toString(),
        selection: newSelection,
      );
    }
    return '';
  }
}
