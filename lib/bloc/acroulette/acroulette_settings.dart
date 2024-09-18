import 'package:equatable/equatable.dart';

class AcrouletteSettings extends Equatable {
  const AcrouletteSettings({
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

  @override
  List<Object?> get props => [
        rNextPosition,
        rNewPosition,
        rPreviousPosition,
        rCurrentPosition,
        mode,
        machine,
      ];
}
