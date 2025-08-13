import 'package:boyboy_cb_gallery_v2/widget/Landing_Page_Widget/description.dart';
import 'package:boyboy_cb_gallery_v2/widget/Landing_Page_Widget/title.dart';
import 'package:boyboy_cb_gallery_v2/widget/Landing_Page_Widget/welcome_button.dart';
import 'package:flutter/material.dart';

double responsiveFont(BuildContext context, double base) {
  final w = MediaQuery.of(context).size.width;
  final scale = (w / 375).clamp(0.85, 1.35); // keep it from going too tiny/huge
  return base * scale;
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF6EC7), // Holo Pink
                Color(0xFFFF4E50), // Reddish Pink
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              TitlePage(),
              Description(),
              SizedBox(
                height: 15,
              ),
              WelcomeButton(),
            ],
          ),
        ),
        // floatingActionButton: OutlinedFAB(
        //   onPressed: () {
        //     debugPrint("FAB pressed!");
        //   },
        // ),
      ),
    );
  }
}
