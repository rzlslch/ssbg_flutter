import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/page_provider.dart';
import 'action_button.dart';

class HeaderButton extends StatelessWidget {
  const HeaderButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider =
        Provider.of<PageProvider>(context, listen: false);
    return Row(
      children: [
        ActionButton(
          function: pageProvider.back,
          text: 'BACK',
          icon: Icons.arrow_back,
        ),
      ],
    );
  }
}
