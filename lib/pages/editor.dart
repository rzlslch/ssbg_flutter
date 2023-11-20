import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssbg_flutter/providers/editor_provider.dart';
import 'package:ssbg_flutter/scripts/md_scanner.dart';
import 'package:ssbg_flutter/widgets/header_button.dart';

import '../widgets/action_button.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final EditorProvider editorProvider =
        Provider.of<EditorProvider>(context, listen: false);
    TextEditingController editorController =
        TextEditingController(text: editorProvider.value);
    Timer? debounce;
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
                function: () {
                  mdScanner(editorController.text);
                },
                text: "GENERATE",
                icon: Icons.replay_rounded)
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
            child: TextFormField(
              controller: editorController,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontSize: 14,
                height: 1.1,
              ),
              onChanged: (value) {
                if (debounce?.isActive ?? false) debounce?.cancel();
                debounce = Timer(const Duration(milliseconds: 500), () {
                  final File file = File(editorProvider.path);
                  file.writeAsString(value);
                });
              },
            ),
          ),
        )))
      ],
    );
  }
}
