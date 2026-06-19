import 'package:flutter/material.dart';

class DiceWidget extends StatefulWidget {
  final int value;
  final bool isRolling;
  final Color color;
  final VoidCallback? onTap;

  const DiceWidget({
    super.key,
    required this.value,
    required this.isRolling,
    required this.color,
    this.onTap,
  });

  @override
  State<DiceWidget> createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotation = Tween<double>(begin: 0, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRolling && !oldWidget.isRolling) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: widget.isRolling ? _rotation.value * 3.14159 : 0,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF11121C),
                border: Border.all(color: widget.color, width: 2.5),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: widget.isRolling
                    ? Icon(Icons.casino, size: 36, color: widget.color)
                    : Text(
                        "${widget.value}",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                          shadows: [
                            Shadow(
                              color: widget.color,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }}
