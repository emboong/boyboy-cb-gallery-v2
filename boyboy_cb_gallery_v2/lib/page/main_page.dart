import 'package:boyboy_cb_gallery_v2/controller/DataController.dart';
import 'package:flutter/material.dart';
import 'package:boyboy_cb_gallery_v2/widget/Main_Page_Widget/fab.dart';
import 'package:boyboy_cb_gallery_v2/widget/Main_Page_Widget/heading.dart';
import 'package:boyboy_cb_gallery_v2/widget/Main_Page_Widget/photoCard.dart';
import 'package:provider/provider.dart';
import 'package:boyboy_cb_gallery_v2/connection/DBConnect.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    // Test connection on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _testInitialConnection();
    });
  }

  Future<void> _testInitialConnection() async {
    final ctrl = context.read<GalleryController>();
    try {
      final result = await ctrl.testConnection();
      if (!result['success'] && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection issue: ${result['message']}'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to test connection: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _showConnectionTestDialog(BuildContext context, GalleryController ctrl) async {
    final result = await ctrl.testConnection();
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(result['success'] ? 'Connection Success' : 'Connection Failed'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show configuration
                const Text('Configuration:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...AppwriteConfig.configSummary.entries.map((entry) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('${entry.key}: ${entry.value}', style: const TextStyle(fontSize: 12)),
                  )
                ),
                const SizedBox(height: 16),
                // Show connection results
                const Text('Connection Test:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...result.entries.map((entry) {
                  if (entry.key == 'success') return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('${entry.key}: ${entry.value}'),
                  );
                }).toList(),
                const SizedBox(height: 16),
                // Show common issues
                const Text('Common Issues & Solutions:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...AppwriteConfig.commonIssues.entries.map((entry) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ${entry.key}:', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                        Text('  ${entry.value}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<GalleryController>();
    final items = ctrl.items;

    return Scaffold(
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
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: RefreshIndicator(
                  onRefresh: () => ctrl.loadItems(),
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Heading(),
                              SizedBox(height: 8),
                              Text(
                                "“Pictures freeze moments in time, but memories last forever.”",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Connection test button in separate SliverToBoxAdapter
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Center(
                            child: ElevatedButton.icon(
                              onPressed: () => _showConnectionTestDialog(context, ctrl),
                              icon: const Icon(Icons.wifi),
                              label: const Text('Test Connection'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (ctrl.loading && items.isEmpty)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                        ),
                      SliverList.builder(
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final item = items[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: PhotoCard(
                              imagePath: item.imageUrl,
                              message: item.message,
                              created: item.createdAt,
                            ),
                          );
                        },
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Pass controller to the FAB (so Save can call ctrl.addItem)
      floatingActionButton: OutlinedFAB(
        controller: ctrl,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:boyboy_cb_gallery_v2/widget/Main_Page_Widget/fab.dart';
// import 'package:boyboy_cb_gallery_v2/widget/Main_Page_Widget/heading.dart';
// import 'package:boyboy_cb_gallery_v2/widget/Main_Page_Widget/photoCard.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   // Demo data – replace with your backend list later
//   final _items = <Map<String, dynamic>>[
//     {
//       'image':
//           'https://pilipinaspopcorn-6009.kxcdn.com/wp-content/uploads/2018/01/22-850x491.jpg',
//       'msg': 'Our first Samal',
//       'date': DateTime.now(),
//     },
//     {
//       'image':
//           'https://pilipinaspopcorn-6009.kxcdn.com/wp-content/uploads/2017/10/Jadinne.jpg',
//       'msg': 'She said YES!',
//       'date': DateTime.now(),
//     },
//     // add as many as you like…
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // NOTE: MainPage should return a Scaffold.
//     // Wrap MaterialApp ABOVE this (in main.dart), not here.
//     return Scaffold(
//       // Full-page holo gradient background
//       body: Stack(
//         children: [
//           const Positioned.fill(
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFFFF6EC7), Color(0xFFFF4E50)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//           ),

//           // Scrollable content
//           SafeArea(
//             child: Center(
//               child: ConstrainedBox(
//                 constraints: const BoxConstraints(maxWidth: 920),
//                 child: CustomScrollView(
//                   slivers: [
//                     // Header + subtitle
//                     const SliverToBoxAdapter(
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Heading(),
//                             SizedBox(height: 8),
//                             Text(
//                               "“Pictures freeze moments in time, but memories last forever.”",
//                               textAlign: TextAlign.center,
//                               style:
//                                   TextStyle(fontSize: 18, color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Cards list (any length)
//                     SliverList(
//                       delegate: SliverChildBuilderDelegate(
//                         (context, index) {
//                           final item = _items[index];
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 10),
//                             child: PhotoCard(
//                               imagePath: item['image'] as String,
//                               message: item['msg'] as String,
//                               created: item['date'] as DateTime,
//                             ),
//                           );
//                         },
//                         childCount: _items.length,
//                       ),
//                     ),

//                     // Bottom spacing so last card isn’t hidden by FAB
//                     const SliverToBoxAdapter(child: SizedBox(height: 100)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),

//       // Your outlined FAB
//       floatingActionButton: OutlinedFAB(
//         onPressed: () {},
//       ),
//     );
//   }
// }
