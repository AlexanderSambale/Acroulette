import 'package:flutter/material.dart';

class SegmentedView extends StatelessWidget {
  const SegmentedView(
      {super.key, required this.selected, required this.onPressed});
  final int selected;
  final Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(192, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: selected == 1
                      ? WidgetStateColor.resolveWith(
                          (states) => const Color.fromARGB(192, 255, 255, 255),
                        )
                      : WidgetStateColor.resolveWith(
                          (states) => const Color.fromARGB(192, 63, 78, 165),
                        )),
              onPressed: () => onPressed(0),
              child: const Text('Position'),
            )),
            Expanded(
                child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: selected == 0
                      ? WidgetStateColor.resolveWith(
                          (states) => const Color.fromARGB(192, 255, 255, 255),
                        )
                      : WidgetStateColor.resolveWith(
                          (states) => const Color.fromARGB(192, 63, 78, 165),
                        )),
              onPressed: () => onPressed(1),
              child: const Text('Category'),
            ))
          ],
        ));
  }
}
