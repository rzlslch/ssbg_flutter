import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.callback});

  final IconData icon;
  final String text;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            elevation: 0,
            fixedSize: const Size(200, 200),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: SizedBox(
          height: 120,
          width: 120,
          child: Center(
            child: Column(
              children: [
                Icon(icon, size: 80),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  text,
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        ));
  }
}
