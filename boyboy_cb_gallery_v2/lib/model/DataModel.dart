class GalleryItem {
  final String id;
  final String imageUrl; // public URL to view the file (if bucket public)
  final String message;
  final DateTime createdAt;

  const GalleryItem({
    required this.id,
    required this.imageUrl,
    required this.message,
    required this.createdAt,
  });
}
