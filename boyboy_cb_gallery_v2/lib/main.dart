import 'package:boyboy_cb_gallery_v2/controller/DataController.dart';
import 'package:flutter/material.dart';
import 'package:boyboy_cb_gallery_v2/page/landing_page.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GalleryController()..loadItems(),
      child: const LandingPage(),
    ),
  );
}
