import 'package:boyboy_cb_gallery_v2/page/main_page.dart';
import 'package:flutter/material.dart';

double responsiveFont(BuildContext context, double base) {
  final w = MediaQuery.of(context).size.width;
  final scale = (w / 375).clamp(0.85, 1.35); // keep it from going too tiny/huge
  return base * scale;
}

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        side: const BorderSide(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          "Lezgow!",
          style: TextStyle(
            fontSize: responsiveFont(context, 18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
