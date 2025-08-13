import 'package:boyboy_cb_gallery_v2/widget/Landing_Page_Widget/fab.dart';
import 'package:boyboy_cb_gallery_v2/widget/Main_Page_Widget/heading.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
          child: const Padding(
            padding: EdgeInsets.all(70.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Heading(),
                SizedBox(height: 2),
                Text(
                    "“Pictures freeze moments in time, but memories last forever.”",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ],
            ),
          ),
        ),
        floatingActionButton: OutlinedFAB(),
      ),
    );
  }
}
