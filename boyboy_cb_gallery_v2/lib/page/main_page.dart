import 'package:flutter/material.dart';
import 'package:boyboy_cb_gallery_v2/widget/Main_Page_Widget/fab.dart';
import 'package:boyboy_cb_gallery_v2/widget/Main_Page_Widget/heading.dart';
import 'package:boyboy_cb_gallery_v2/widget/Main_Page_Widget/photoCard.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Demo data – replace with your backend list later
  final _items = <Map<String, dynamic>>[
    {
      'image':
          'https://pilipinaspopcorn-6009.kxcdn.com/wp-content/uploads/2018/01/22-850x491.jpg',
      'msg': 'Our first Samal',
      'date': DateTime.now(),
    },
    {
      'image':
          'https://pilipinaspopcorn-6009.kxcdn.com/wp-content/uploads/2017/10/Jadinne.jpg',
      'msg': 'She said YES!',
      'date': DateTime.now(),
    },
    // add as many as you like…
  ];

  @override
  Widget build(BuildContext context) {
    // NOTE: MainPage should return a Scaffold.
    // Wrap MaterialApp ABOVE this (in main.dart), not here.
    return Scaffold(
      // Full-page holo gradient background
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF6EC7), Color(0xFFFF4E50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Scrollable content
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: CustomScrollView(
                  slivers: [
                    // Header + subtitle
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Heading(),
                            SizedBox(height: 8),
                            Text(
                              "“Pictures freeze moments in time, but memories last forever.”",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Cards list (any length)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = _items[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: PhotoCard(
                              imagePath: item['image'] as String,
                              message: item['msg'] as String,
                              created: item['date'] as DateTime,
                            ),
                          );
                        },
                        childCount: _items.length,
                      ),
                    ),

                    // Bottom spacing so last card isn’t hidden by FAB
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Your outlined FAB
      floatingActionButton: const OutlinedFAB(),
    );
  }
}
