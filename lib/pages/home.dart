import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:ssbg_flutter/models/file_model.dart';
import 'package:ssbg_flutter/providers/list_provider.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/providers/page_provider.dart';
import 'package:ssbg_flutter/scripts/setup_dir.dart';
import 'package:ssbg_flutter/widgets/menu_button.dart';

List menu = <Map>[
  {"title": "Config", "icon": Icons.settings, "folder": "_config"},
  {"title": "Include", "icon": Icons.note_add, "folder": "_include"},
  {"title": "Layout", "icon": Icons.format_align_left, "folder": "_layout"},
  {"title": "Page", "icon": Icons.find_in_page_sharp, "folder": "_page"},
  {"title": "Post", "icon": Icons.post_add_sharp, "folder": "_post"}
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider =
        Provider.of<PageProvider>(context, listen: false);
    // GlobalProvider globalProvider = Provider.of(context, listen: false);
    ListProvider listProvider = Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading:
            Consumer<GlobalProvider>(builder: (context, globalProvider, _) {
          return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1))),
              onPressed: () => setupDir(globalProvider),
              child: const SizedBox(
                  width: 200, child: Center(child: Icon(Icons.folder))));
        }),
        title: Consumer<GlobalProvider>(
          builder: (context, globalProvider, _) => Text(globalProvider.blogDir),
        ),
      ),
      body: Center(
        child: Consumer<GlobalProvider>(builder: (context, globalProvider, _) {
          return Visibility(
            visible: globalProvider.blogDir != "",
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 40,
              runSpacing: 40,
              children: List.generate(
                  menu.length,
                  (index) => MenuButton(
                        icon: menu[index]["icon"],
                        text: menu[index]["title"],
                        callback: () {
                          var globDir = globalProvider.blogDir;
                          var menuDir = menu[index]["folder"];
                          if (menuDir == "_config") {
                            pageProvider.setPageForm();
                          } else {
                            pageProvider.setPageList();
                          }
                          pageProvider.update(1);
                          pageProvider.setPageDir(menuDir);
                          var listFiles =
                              Directory(join(globDir, menuDir)).listSync();
                          List<FileModel> listFile = listFiles
                              .map(
                                (e) {
                                  String filename = e.path
                                      .replaceAll(e.parent.path, "")
                                      .substring(1);
                                  FileModel fileInfo = FileModel(
                                      filename: filename, path: e.path);
                                  return fileInfo;
                                },
                              )
                              .cast<FileModel>()
                              .toList();
                          listProvider.setList(listFile);
                          listProvider.setDir(menuDir);
                        },
                      )),
            ),
          );
        }),
      ),
    );
  }
}
