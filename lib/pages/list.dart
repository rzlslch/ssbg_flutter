import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssbg_flutter/pages/scenes/form_scene.dart';
import 'package:ssbg_flutter/pages/scenes/list_scene.dart';
import 'package:ssbg_flutter/providers/page_provider.dart';
import 'package:ssbg_flutter/widgets/header_button.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider =
        Provider.of<PageProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderButton(),
        const SizedBox(
          height: 10,
        ),
        pageProvider.pageType == "list" ? const ListScene() : const FormScene()
      ],
    );
  }
}
