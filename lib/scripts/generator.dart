import 'package:intl/intl.dart';
import 'package:liquid_engine/liquid_engine.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/scripts/html_scanner.dart';
import 'package:ssbg_flutter/scripts/layout_scanner.dart';
import 'package:ssbg_flutter/scripts/config_scanner.dart';
import 'package:ssbg_flutter/scripts/md_scanner.dart';

Future<void> generator(GlobalProvider globalProvider, String markdown) async {
  var mdConfig = configScanner(markdown);
  String layout = mdConfig.$1!.layout;
  String content = mdScanner(mdConfig.$2);

  var layoutScanned = layoutScanner(globalProvider, layout, content);
  var htmlScanned = htmlScanner(globalProvider, layoutScanned);
  // print(htmlScanned);
  final context = Context.create();
  context.variables['site'] = {'title': '@rzlslch'};
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
  final template = Template.parse(context, Source.fromString(htmlScanned));
  print(await template.render(context));
}
