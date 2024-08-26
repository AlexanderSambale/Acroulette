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
        onPressed: onPressed,
      ),
    ),
  );
}

createSwitch({
  required double size,
  required bool isSwitched,
  required bool enabled,
  required void Function(bool) onChanged,
  required BuildContext context,
}) {
  ThemeData theme = Theme.of(context);

  return SizedBox(
    width: size * 1.75,
    height: size,
    child: FittedBox(
      fit: BoxFit.fill,
      child: Switch(
        value: isSwitched,
        onChanged: enabled ? onChanged : null,
        activeColor: enabled
            ? theme.toggleButtonsTheme.color
            : theme.toggleButtonsTheme.disabledColor,
      ),
    ),
  );
}
