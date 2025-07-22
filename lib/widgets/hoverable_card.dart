import 'package:flutter/material.dart';

class HoverableCard extends StatefulWidget {
  final Widget child;

  const HoverableCard({super.key, required this.child});

  @override
  State<HoverableCard> createState() => _HoverableCardState();
}

class _HoverableCardState extends State<HoverableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform:
            _isHovered
                ? Matrix4.translationValues(0, -10, 0)
                : Matrix4.identity(),
        child: widget.child,
      ),
    );
  }
}
