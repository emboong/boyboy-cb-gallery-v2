import 'dart:io' as io;
import 'package:boyboy_cb_gallery_v2/connection/DBConnect.dart';
import 'package:boyboy_cb_gallery_v2/model/DataModel.dart';
import 'package:flutter/foundation.dart';
import 'package:appwrite/appwrite.dart';

class GalleryController extends ChangeNotifier {
  // Appwrite clients
  late final Client _client;
  late final Databases _db;
  late final Storage _storage;

  final List<GalleryItem> _items = [];
  List<GalleryItem> get items => List.unmodifiable(_items);

  bool _loading = false;
  bool get loading => _loading;

  // Static counter for generating unique IDs
  static int _idCounter = 1;

  GalleryController() {
    _client = Client()
      ..setEndpoint(AppwriteConfig.endpoint)
      ..setProject(AppwriteConfig.projectId);
    _db = Databases(_client);
    _storage = Storage(_client);
  }

  /// Helper to build a public View URL for a file.
  /// Tries multiple URL formats to find one that works.
  String _buildFileViewUrl(String fileId) {
    // Keep /v1. Only trim trailing slash.
    final ep = AppwriteConfig.endpoint.replaceFirst(RegExp(r'/$'), '');
    final url =
        '$ep/storage/buckets/${AppwriteConfig.bucketId}/files/$fileId/view'
        '?project=${AppwriteConfig.projectId}';
    debugPrint('Image URL: $url');
    return url;
  }

  Future<void> loadItems() async {
    _loading = true;
    notifyListeners();

    try {
      debugPrint('Loading items from database...');
      debugPrint('Database ID: ${AppwriteConfig.databaseId}');
      debugPrint('Collection ID: ${AppwriteConfig.collectionId}');

      final res = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        queries: [
          Query.orderDesc('\$createdAt'),
          Query.limit(100),
        ],
      );

      debugPrint('Retrieved ${res.documents.length} documents');

      _items
        ..clear()
        ..addAll(res.documents.map((d) {
          final fileId =
              d.data['image'] as String; // Changed from 'imageId' to 'image'
          debugPrint('Processing document with fileId: $fileId');

          final url = AppwriteConfig.bucketIsPublic
              ? _buildFileViewUrl(fileId)
              : ''; // (If not public, you'll render bytes another way)

          debugPrint('Generated image URL: $url');

          final createdIso = d.$createdAt; // String
          final created = DateTime.tryParse(d.data['date'] as String? ?? '') ??
              DateTime.tryParse(createdIso) ??
              DateTime.now();

          return GalleryItem(
            id: d.$id, // This is the document ID from Appwrite
            imageUrl: url,
            message: (d.data['message'] ?? '') as String,
            createdAt: created,
          );
        }));

      debugPrint('Items loaded successfully: ${_items.length} items');
    } catch (e) {
      debugPrint('loadItems error: $e');
      debugPrint('Error type: ${e.runtimeType}');
      if (e is AppwriteException) {
        debugPrint('Appwrite error code: ${e.code}');
        debugPrint('Appwrite error message: ${e.message}');
        debugPrint('Appwrite error response: ${e.response}');
      }
      // Don't rethrow here as this is called during initialization
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Creates: 1) file in Storage  2) document in Database  3) refresh list
  Future<void> addItem({
    required String message,
    io.File? imageFile,
    Uint8List? imageBytes,
    String? filename,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      // Validate inputs
      if (message.trim().isEmpty) {
        throw Exception('Message cannot be empty');
      }

      if (imageFile == null && imageBytes == null) {
        throw Exception('Image file or bytes must be provided');
      }

      debugPrint('Starting addItem process...');
      debugPrint('Message: $message');
      debugPrint('ImageFile: ${imageFile?.path}');
      debugPrint('ImageBytes: ${imageBytes?.length} bytes');
      debugPrint('Filename: $filename');

      // Choose the right InputFile depending on platform
      final InputFile inputFile = (kIsWeb || imageFile == null)
          ? InputFile.fromBytes(
              bytes: imageBytes!, // must not be null on web
              filename: filename ?? 'upload.jpg',
            )
          : InputFile.fromPath(
              path: imageFile.path,
              filename:
                  filename ?? imageFile.uri.pathSegments.last, // nice to have
            );

      debugPrint('Created InputFile: ${inputFile.filename}');

      // Step 1: Upload file to storage
      debugPrint('Uploading file to storage...');
      final file = await _storage.createFile(
        bucketId: AppwriteConfig.bucketId,
        fileId: ID.unique(),
        file: inputFile,
      );
      debugPrint('File uploaded successfully: ${file.$id}');

      // Step 2: Create document in database
      debugPrint('Creating document in database...');
      final documentId = ID.unique();
      final document = await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId:
            documentId.toString(), // Convert to string for documentId parameter
        data: {
          'id': documentId, // This will be a unique 32-bit integer
          'message': message,
          'image':
              file.$id, // Changed from 'imageId' to 'image' to match schema
          'date': DateTime.now()
              .toIso8601String(), // Changed from 'createdAt' to 'date' to match schema
        },
      );
      debugPrint('Document created successfully: ${document.$id}');

      // Step 3: Refresh the list
      debugPrint('Refreshing items list...');
      await loadItems();
      debugPrint('addItem completed successfully');
    } catch (e) {
      debugPrint('addItem error: $e');
      debugPrint('Error type: ${e.runtimeType}');

      String userFriendlyMessage = 'An error occurred while adding the item';

      if (e is AppwriteException) {
        debugPrint('Appwrite error code: ${e.code}');
        debugPrint('Appwrite error message: ${e.message}');
        debugPrint('Appwrite error response: ${e.response}');

        // Provide user-friendly error messages
        switch (e.code) {
          case 400:
            userFriendlyMessage =
                'Document structure error. Please check your Appwrite collection schema.';
            break;
          case 401:
            userFriendlyMessage =
                'Authentication failed. Please check your Appwrite configuration.';
            break;
          case 403:
            userFriendlyMessage =
                'Permission denied. Please check collection and bucket permissions in Appwrite console.';
            break;
          case 404:
            userFriendlyMessage =
                'Database, collection, or bucket not found. Please verify your Appwrite configuration.';
            break;
          case 409:
            userFriendlyMessage =
                'A document with this ID already exists. Please try again.';
            break;
          case 413:
            userFriendlyMessage =
                'File is too large. Please choose a smaller image.';
            break;
          case 429:
            userFriendlyMessage =
                'Too many requests. Please wait a moment and try again.';
            break;
          default:
            userFriendlyMessage = 'Appwrite error: ${e.message}';
        }
      } else if (e.toString().contains('permission')) {
        userFriendlyMessage =
            'Permission denied. Please check your Appwrite collection and bucket permissions.';
      } else if (e.toString().contains('network')) {
        userFriendlyMessage =
            'Network error. Please check your internet connection and try again.';
      }

      // Create a custom exception with user-friendly message
      throw Exception(userFriendlyMessage);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Optional: delete an item (if you add a delete button later)
  Future<void> deleteItem(GalleryItem item, {String? imageId}) async {
    _loading = true;
    notifyListeners();
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        documentId: item.id,
      );
      if (imageId != null) {
        await _storage.deleteFile(
          bucketId: AppwriteConfig.bucketId,
          fileId: imageId,
        );
      }
      await loadItems();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Test the Appwrite connection and permissions
  Future<Map<String, dynamic>> testConnection() async {
    try {
      debugPrint('Testing Appwrite connection...');

      // Test database connection
      final dbTest = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.collectionId,
        queries: [Query.limit(1)],
      );
      debugPrint('Database connection: SUCCESS');

      // Test storage connection
      final storageTest = await _storage.listFiles(
        bucketId: AppwriteConfig.bucketId,
        queries: [Query.limit(1)],
      );
      debugPrint('Storage connection: SUCCESS');

      return {
        'success': true,
        'database': 'Connected',
        'storage': 'Connected',
        'documentCount': dbTest.total,
        'fileCount': storageTest.total,
      };
    } catch (e) {
      debugPrint('Connection test failed: $e');
      if (e is AppwriteException) {
        return {
          'success': false,
          'error': 'Appwrite Error',
          'code': e.code,
          'message': e.message,
        };
      }
      return {
        'success': false,
        'error': 'Unknown Error',
        'message': e.toString(),
      };
    }
  }
}
