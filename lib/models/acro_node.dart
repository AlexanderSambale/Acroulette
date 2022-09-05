class AcroNode {
  AcroNode(
      this.key, this.isSwitched, this.label, this.onSwitchChange, this.delete);

  String key;
  bool isSwitched;
  String label;
  void Function(bool) onSwitchChange;
  void Function() delete;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AcroNode && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;
}
