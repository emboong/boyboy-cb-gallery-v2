import 'dart:ui';
import 'package:flutter/material.dart';

class GlassField extends StatelessWidget {
  final Widget child;
  const GlassField({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        // very light blur so background doesn’t overwhelm
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: DecoratedBox(
          decoration: BoxDecoration(
            // soft blush gradient that blends with the holo bg
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFF6EA1).withOpacity(0.20), // blush pink
                const Color(0xFFFF1F4D).withOpacity(0.10), // warm red
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            // lighter border so it doesn’t pop too hard
            border: Border.all(color: Colors.white.withOpacity(0.22)),
            // soft glow for separation from background
            boxShadow: const [
              BoxShadow(
                color: Color(0x26FF0055), // subtle pink shadow
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          // faint inner veil to increase legibility without looking opaque
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(14),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
