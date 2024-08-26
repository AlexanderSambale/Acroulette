import 'package:flutter/material.dart';

createIconButton({
  required BuildContext context,
  required double padding,
  required double size,
  required icon,
  required tooltip,
  required void Function() onPressed,
}) {
  return Padding(
    padding: EdgeInsets.only(left: padding, right: padding),
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size),
      child: IconButton(
          padding: const EdgeInsets.all(0),
          icon: icon,
          tooltip: tooltip,
          onPressed: onPressed),
    ),
  );
}
