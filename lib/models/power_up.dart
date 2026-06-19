import '../core/enums/power_up_type.dart';

class PowerUp {
  final PowerUpType type;
  final String name;
  final String description;
  final int duration;

  PowerUp({
    required this.type,
    required this.name,
    required this.description,
    this.duration = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'name': name,
      'description': description,
      'duration': duration,
    };
  }

  factory PowerUp.fromJson(Map<String, dynamic> json) {
    return PowerUp(
      type: PowerUpType.values[json['type']],
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
    );
  }
}
