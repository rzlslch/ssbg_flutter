import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssbg_flutter/pages/editor.dart';
import 'package:ssbg_flutter/pages/home.dart';
import 'package:ssbg_flutter/pages/list.dart';
import 'package:ssbg_flutter/providers/list_provider.dart';
import 'package:ssbg_flutter/providers/editor_provider.dart';
import 'package:ssbg_flutter/providers/global_provider.dart';
import 'package:ssbg_flutter/providers/page_provider.dart';
import 'package:ssbg_flutter/providers/server_provider.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WindowOptions windowOptions =
        const WindowOptions(size: Size(800, 800), center: true, title: "ssbg");
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ssbg',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ssbg'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List pages = <Widget>[const HomePage(), const ListPage(), const EditorPage()];
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => PageProvider()),
        ChangeNotifierProvider(create: (ctx) => GlobalProvider()),
        ChangeNotifierProvider(create: (ctx) => ListProvider()),
        ChangeNotifierProvider(create: (ctx) => EditorProvider()),
        ChangeNotifierProvider(create: (ctx) => ServerProvider()),
      ],
      child: Container(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Consumer<PageProvider>(
              builder: (context, pageProvider, child) =>
                  pages[pageProvider.pageIndex],
            )),
      ),
    );
  }
}
