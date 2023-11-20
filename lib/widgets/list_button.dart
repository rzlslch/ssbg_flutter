import 'package:flutter/material.dart';

class ListButton extends StatelessWidget {
  const ListButton({
    super.key,
    required this.title,
    required this.function,
  });

  final String title;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: TextButton(
          onPressed: function,
          style: TextButton.styleFrom(
              backgroundColor: Colors.amber,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0))),
          child: Align(alignment: Alignment.centerLeft, child: Text(title))),
    );
  }
}
