class AcrouletteSettings {
  AcrouletteSettings({
    required this.rNextPosition,
    required this.rNewPosition,
    required this.rPreviousPosition,
    required this.rCurrentPosition,
    required this.mode,
    required this.machine,
  });
  final RegExp rNextPosition;
  final RegExp rNewPosition;
  final RegExp rPreviousPosition;
  final RegExp rCurrentPosition;
  final String mode;
  final String machine;

  AcrouletteSettings copyWith({
    RegExp? rNextPosition,
    RegExp? rNewPosition,
    RegExp? rPreviousPosition,
    RegExp? rCurrentPosition,
    String? mode,
    String? machine,
  }) {
    return AcrouletteSettings(
      rNextPosition: rNextPosition ?? this.rNextPosition,
      rNewPosition: rNewPosition ?? this.rNewPosition,
      rPreviousPosition: rPreviousPosition ?? this.rPreviousPosition,
      rCurrentPosition: rCurrentPosition ?? this.rCurrentPosition,
      mode: mode ?? this.mode,
      machine: machine ?? this.machine,
    );
  }
}

/*   final RegExp get rNextPosition => RegExp(settingsRepository.get(nextPosition));
  final RegExp get rNewPosition => RegExp(settingsRepository.get(newPosition));
  final RegExp get rPreviousPosition =>
      RegExp(settingsRepository.get(previousPosition));
  final RegExp get rCurrentPosition =>
      RegExp(settingsRepository.get(currentPosition)); */