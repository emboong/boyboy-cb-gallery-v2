import 'package:flutter/material.dart';
import 'dart:io';

class PhotoCard extends StatelessWidget {
  final String imagePath; // Local file path or network URL
  final String message;
  final DateTime created;

  const PhotoCard({
    super.key,
    required this.imagePath,
    required this.message,
    required this.created,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
        constraints: const BoxConstraints(maxWidth: 500), // max width limit
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image (smaller aspect ratio)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 250, // smaller height
                child: _buildImage(context),
              ),
            ),

            // Message and date
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "“$message”",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(created),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (imagePath.startsWith('http')) {
      return GestureDetector(
        onTap: () => _showFullScreenImage(context, imagePath),
        child: Image.network(
          imagePath,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[300],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Image loading error: $error');
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Image failed to load',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else if (imagePath.isNotEmpty) {
      return GestureDetector(
        onTap: () => _showFullScreenImage(context, imagePath),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Local image loading error: $error');
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      );
    } else {
      // No image path provided
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 50,
            color: Colors.grey,
          ),
        ),
      );
    }
  }

  void _showFullScreenImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Full screen image
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: InteractiveViewer(
                        panEnabled: true,
                        boundaryMargin: const EdgeInsets.all(20.0),
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: imagePath.startsWith('http')
                            ? Image.network(
                                imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[800],
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.broken_image,
                                            size: 100,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Image failed to load',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Image.file(
                                File(imagePath),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[800],
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 100,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              // Close button
              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              // Zoom instructions
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Pinch to zoom • Tap to close',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
