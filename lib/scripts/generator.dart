import 'dart:io';

import 'package:intl/intl.dart';
import 'package:liquid_engine/liquid_engine.dart';
import 'package:ssbg_flutter/models/config_model.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/scripts/html_scanner.dart';
import 'package:ssbg_flutter/scripts/layout_scanner.dart';
import 'package:ssbg_flutter/scripts/config_scanner.dart';
import 'package:ssbg_flutter/scripts/md_scanner.dart';

Future<(ConfigModel, String)> generator(
    GlobalProvider globalProvider, String path) async {
  File file = File(path);
  String markdown = file.readAsStringSync();
  var mdConfig = configScanner(markdown);
  String layout = mdConfig.$1!.layout;
  String content = mdScanner(globalProvider, mdConfig.$2);

  var layoutScanned = layoutScanner(globalProvider, layout, content);
  var htmlScanned = htmlScanner(globalProvider, layoutScanned);

  List<ConfigModel> listPost = globalProvider.listPost
      .map((e) => configScanner(File(e.path).readAsStringSync()).$1)
      .cast<ConfigModel>()
      .toList();

  Map mapListPost = listPost.asMap();
  for (var c in mapListPost.entries) {
    int idx = c.key;
    ConfigModel value = c.value;
    if (mapListPost[idx - 1] != null) {
      value.setNext(listPost[idx - 1]);
    }
    if (mapListPost[idx + 1] != null) {
      value.setPrev(listPost[idx + 1]);
    }
    listPost[idx] = value;
  }

  final context = Context.create();
  context.variables['site'] = {};
  for (var c in globalProvider.config.entries) {
    context.variables['site'][c.key] = c.value;
  }

  context.variables['site']['posts'] = [
    ...listPost.map((e) {
      Map value = e.toMap();
      return value;
    }).toList()
  ];
  context.variables['page'] = {
    'layout': mdConfig.$1!.layout,
    'title': mdConfig.$1!.title,
    'date': mdConfig.$1!.date,
    'permalink': mdConfig.$1!.permalink,
    'categories': mdConfig.$1!.categories,
    'comments': mdConfig.$1!.comments,
  };
  context.filters['date'] = (input, args) {
    List dateList = input.toString().trim().split(" ");
    List dateYMD = dateList[0].toString().split("-");
    List dateH = dateList[1].toString().split(":");
    DateTime timestamp = DateTime(int.parse(dateYMD[0]), int.parse(dateYMD[1]),
        int.parse(dateYMD[2]), int.parse(dateH[0]), int.parse(dateH[1]));
    String parseArgs = "";
    for (var c in args) {
      String argsParse = c.toString();
      argsParse = argsParse.replaceAll("%a", "E");
      argsParse = argsParse.replaceAll("%A", "EEEE");
      argsParse = argsParse.replaceAll("%d", "dd");
      argsParse = argsParse.replaceAll("%m", "MM");
      argsParse = argsParse.replaceAll("%b", "MMM");
      argsParse = argsParse.replaceAll("%B", "MMMM");
      argsParse = argsParse.replaceAll("%Y", "y");
      parseArgs = argsParse;
    }

    String formatted = DateFormat(parseArgs).format(timestamp);

    return formatted;
  };

  final template = Template.parse(context, Source.fromString(htmlScanned));
  String render = await template.render(context);
  // print(render);
  return (mdConfig.$1!, render);
}
