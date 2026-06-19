import 'package:flutter/material.dart';
import 'game_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040508),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.casino,
              size: 80,
              color: Colors.cyan,
            ),
            const SizedBox(height: 20),
            const Text(
              '🎮 مار و پەیژە 🎮',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Cyber Snake & Ladders',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 50),
            _buildMenuButton(
              'دەستپێکردنی یاری',
              Icons.play_arrow,
              Colors.cyan,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
            ),
            const SizedBox(height: 20),            _buildMenuButton(
              'ڕێنمایی',
              Icons.help_outline,
              Colors.purple,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('بەم زووانە...')),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildMenuButton(
              'ڕێکخستنەکان',
              Icons.settings,
              Colors.amber,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('بەم زووانە...')),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              'v1.0.0',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 280,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF11121C),
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: color.withValues(alpha: 0.5), width: 2),
          ),
          elevation: 8,
          shadowColor: color.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
