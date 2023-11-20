import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.function,
    required this.text,
    required this.icon,
  });

  final VoidCallback function;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.amber,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
        onPressed: function,
        child: SizedBox(
            height: 20,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(text)
                ],
              ),
            )));
  }
}
