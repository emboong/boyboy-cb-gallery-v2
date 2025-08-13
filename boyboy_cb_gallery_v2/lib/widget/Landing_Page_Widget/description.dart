import 'package:flutter/material.dart';

EdgeInsets responsivePadding(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  double horizontal = w < 400 ? 20 : 40; // more padding on small screens
  return EdgeInsets.symmetric(horizontal: horizontal);
}

class Description extends StatelessWidget {
  const Description({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: responsivePadding(context),
      child: const Text(
        "Post your Magical and most Memorable Photo Together!",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          shadows: [
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
