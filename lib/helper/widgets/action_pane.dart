double calculateExtentRatio({
  required double size,
  required double padding,
  required double maxWidth,
  required int numberOfWidgets,
}) {
  return ((size + padding * 2) * numberOfWidgets + 2 * padding) / maxWidth;
}
