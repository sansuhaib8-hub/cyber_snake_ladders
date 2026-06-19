import 'package:flutter/material.dart';

class Player {
  final String id;
  String name;
  int position;
  final Color color;
  bool isWinner;
  bool hasShield;

  Player({
    required this.id,
    required this.name,
    this.position = 0,
    required this.color,
    this.isWinner = false,
    this.hasShield = false,
  });

  Player copyWith({
    String? name,
    int? position,
    bool? isWinner,
    bool? hasShield,
  }) {
    return Player(
      id: id,
      name: name ?? this.name,
      position: position ?? this.position,
      color: color,
      isWinner: isWinner ?? this.isWinner,
      hasShield: hasShield ?? this.hasShield,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'color': color.toARGB32(),
      'isWinner': isWinner,
      'hasShield': hasShield,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      color: Color(json['color']),
      isWinner: json['isWinner'] ?? false,
      hasShield: json['hasShield'] ?? false,
    );
  }
}
