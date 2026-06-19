import 'package:flutter/material.dart';
import '../../models/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final bool isCurrent;
  final VoidCallback onTap;

  const PlayerCard({
    super.key,
    required this.player,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isCurrent ? player.color : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isCurrent ? player.color.withValues(alpha: 0.15) : Colors.transparent,
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: player.color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: player.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: player.color.withValues(alpha: 0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  player.name,
                  style: TextStyle(
                    color: isCurrent ? player.color : Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "خانەی: ${player.position}",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
