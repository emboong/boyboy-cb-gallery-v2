import 'package:flutter/material.dart';

double responsiveFont(BuildContext context, double base) {
  final w = MediaQuery.of(context).size.width;
  final scale = (w / 375).clamp(0.85, 1.35); // keep it from going too tiny/huge
  return base * scale;
}

EdgeInsets responsivePadding(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  double horizontal = w < 400 ? 20 : 40; // more padding on small screens
  return EdgeInsets.symmetric(horizontal: horizontal);
}

class Heading extends StatelessWidget {
  const Heading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: responsivePadding(context),
      child: Text(
        "Our Unforgettable Moments",
        style: TextStyle(
          color: Colors.white,
          fontSize: responsiveFont(context, 28),
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(
              blurRadius: 10,
              color: Colors.black45,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }
}
