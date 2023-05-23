import 'package:flutter/material.dart';

class SegmentedView extends StatelessWidget {
  const SegmentedView(
      {Key? key, required this.selected, required this.onPressed})
      : super(key: key);
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
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(192, 255, 255, 255),
                        )
                      : MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(192, 63, 78, 165),
                        )),
              onPressed: () => onPressed(0),
              child: const Text('Position'),
            )),
            Expanded(
                child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: selected == 0
                      ? MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(192, 255, 255, 255),
                        )
                      : MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(192, 63, 78, 165),
                        )),
              onPressed: () => onPressed(1),
              child: const Text('Category'),
            ))
          ],
        ));
  }
}
