class AppwriteConfig {
  static const endpoint =
      'https://fra.cloud.appwrite.io/v1'; // e.g. https://cloud.appwrite.io/v1
  static const projectId = '68a3de440003f55f2a03';

  // Database + collection that will store gallery documents
  static const databaseId = '68a3de8d001b1632077a';
  static const collectionId = '68a3debd001c715040a1';

  // Storage bucket for images
  static const bucketId = '68a3e00d0028eb74c375';

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
