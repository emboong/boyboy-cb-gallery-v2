import 'dart:io';
import 'dart:ui';
import 'package:boyboy_cb_gallery_v2/widget/Main_Page_Widget/glassfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OutlinedFAB extends StatelessWidget {
  final IconData icon;
  final Color outlineColor;
  final double outlineWidth;

  const OutlinedFAB({
    super.key,
    this.icon = Icons.add,
    this.outlineColor = Colors.white,
    this.outlineWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: outlineColor,
          width: outlineWidth,
        ),
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () => _openAddSheet(context),
        child: Icon(icon, size: 28, color: outlineColor),
      ),
    );
  }

  void _openAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return const _AddNoteSheet();
      },
    );
  }
}

String? _selectedImagePath;

class _AddNoteSheet extends StatefulWidget {
  const _AddNoteSheet();

  @override
  State<_AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<_AddNoteSheet> {
  final _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.25)),
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const Text(
                  'Add to Gallery',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),

                const SizedBox(height: 12),

                // Sweet message
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your message',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                GlassField(
                  child: TextField(
                    controller: _msgCtrl,
                    maxLength: 300,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      counterText: "",
                      hintText: "Write something sweet…",
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Photo picker button (UI only)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Photo',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                GlassField(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () async {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                            source:
                                ImageSource.gallery, // or ImageSource.camera
                            maxWidth: 1080,
                            maxHeight: 1080,
                            imageQuality: 85, // 0-100
                          );

                          if (pickedFile != null) {
                            setState(() {
                              // store the selected image file path
                              _selectedImagePath = pickedFile.path;
                            });
                          }
                        },
                        leading: const Icon(Icons.image, color: Colors.white),
                        title: Text(
                          _selectedImagePath != null
                              ? 'Image selected'
                              : 'Choose an image…',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(Icons.chevron_right,
                            color: Colors.white),
                        dense: true,
                      ),
                      if (_selectedImagePath != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_selectedImagePath!),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.7)),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.transparent,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: save logic here sample
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          side: const BorderSide(color: Colors.white, width: 2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
