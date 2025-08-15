class AppwriteConfig {
  static const endpoint =
      'https://nyc.cloud.appwrite.io/v1'; // e.g. https://cloud.appwrite.io/v1
  static const projectId = '689d70d00035793d137c';

  // Database + collection that will store gallery documents
  static const databaseId = '689d92be001ee71b56fa';
  static const collectionId = '689d92c50019daed7888';

  // Storage bucket for images
  static const bucketId = '689d973b001a052e540e';

  // If your bucket is set to public (recommended for simple Image.network)
  // set this to true. Otherwise, you'll need auth and use bytes rendering.
  static const bucketIsPublic = true;

  /// Validate the configuration
  static bool get isValid {
    return endpoint.isNotEmpty &&
           projectId.isNotEmpty &&
           databaseId.isNotEmpty &&
           collectionId.isNotEmpty &&
           bucketId.isNotEmpty;
  }

  /// Get configuration summary for debugging
  static Map<String, String> get configSummary {
    return {
      'Endpoint': endpoint,
      'Project ID': projectId,
      'Database ID': databaseId,
      'Collection ID': collectionId,
      'Bucket ID': bucketId,
      'Bucket Public': bucketIsPublic.toString(),
    };
  }

  /// Common Appwrite permission issues and solutions
  static Map<String, String> get commonIssues {
    return {
      'Collection Permissions': 'Ensure collection has create:["*"] permission',
      'Bucket Permissions': 'Ensure bucket has create:["*"] permission',
      'Database Permissions': 'Ensure database has read:["*"] permission',
      'Project Status': 'Check if project is active and not suspended',
      'API Keys': 'Verify project has proper API keys configured',
      'CORS Settings': 'Check if CORS is configured for your domain',
    };
  }

  /// Get the base URL for file viewing
  static String get baseUrl {
    return endpoint.replaceAll('/v1', '');
  }
}
