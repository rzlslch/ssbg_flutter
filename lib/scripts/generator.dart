import 'dart:io';

import 'package:intl/intl.dart';
import 'package:liquid_engine/liquid_engine.dart';
import 'package:ssbg_flutter/models/config_model.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/scripts/html_scanner.dart';
import 'package:ssbg_flutter/scripts/layout_scanner.dart';
import 'package:ssbg_flutter/scripts/config_scanner.dart';
import 'package:ssbg_flutter/scripts/md_scanner.dart';

Future<String> generator(GlobalProvider globalProvider, String markdown) async {
  var mdConfig = configScanner(markdown);
  String layout = mdConfig.$1!.layout;
  String content = mdScanner(mdConfig.$2);

  var layoutScanned = layoutScanner(globalProvider, layout, content);
  var htmlScanned = htmlScanner(globalProvider, layoutScanned);

  List<ConfigModel> listPost = globalProvider.listPost
      .map((e) => configScanner(File(e.path).readAsStringSync()).$1)
      .cast<ConfigModel>()
      .toList();

  List<ConfigModel> listPage = globalProvider.listPage
      .map((e) => configScanner(File(e.path).readAsStringSync()).$1)
      .cast<ConfigModel>()
      .toList();

  final context = Context.create();
  context.variables['site'] = {
    'title': '@rzlslch',
    'posts': [
      ...listPost
          .map((e) => {
                'title': e.title,
                'layout': e.layout,
                'permalink': e.permalink,
                'date': e.date,
                'categories': e.categories,
                'comments': e.comments
              })
          .toList()
    ]
  };
  context.variables['page'] = {
    'title': mdConfig.$1!.title,
    'date': mdConfig.$1!.date,
    'permalink': mdConfig.$1!.permalink,
    'categories': mdConfig.$1!.categories,
    'comments': mdConfig.$1!.comments,
  };
  context.filters['date'] = (input, args) {
    List dateList = input.trim().split(" ");
    List dateYMD = dateList[0].split("-");
    List dateH = dateList[1].split(":");
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
  print(context.variables);
  final template = Template.parse(context, Source.fromString(htmlScanned));
  String render = await template.render(context);
  print(render);
  return render;
}
