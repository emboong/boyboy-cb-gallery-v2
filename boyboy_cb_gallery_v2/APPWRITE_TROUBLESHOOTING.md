# Appwrite Troubleshooting Guide

## Common Issues When Adding to Database

### 1. Permission Issues
The most common cause of database addition failures is incorrect permissions in your Appwrite console.

**Check these permissions in your Appwrite Console:**

#### Collection Permissions
- Go to Databases → Your Database → Your Collection → Settings → Permissions
- Ensure you have: `create:["*"]` (allows anyone to create documents)
- Also check: `read:["*"]` (allows reading documents)

#### Bucket Permissions  
- Go to Storage → Your Bucket → Settings → Permissions
- Ensure you have: `create:["*"]` (allows file uploads)
- Also check: `read:["*"]` (allows file downloads)

#### Database Permissions
- Go to Databases → Your Database → Settings → Permissions
- Ensure you have: `read:["*"]` (allows reading from database)

### 2. Project Configuration
- Verify your project is active and not suspended
- Check if you have proper API keys configured
- Ensure CORS is configured for your domain (if running on web)

### 3. Collection Schema
Make sure your collection has the correct attributes:
- `message` (string) - for the gallery message
- `imageId` (string) - for the uploaded file ID
- `createdAt` (string) - for the timestamp

### 4. Testing Connection
Use the "Test Connection" button in the app to:
- Verify all configurations are correct
- Test database and storage connectivity
- See detailed error messages

## Quick Fix Steps

1. **Check Appwrite Console Permissions** (most common fix)
2. **Verify Project Status** - ensure project is active
3. **Test Connection** - use the test button in the app
4. **Check Console Logs** - look for detailed error messages
5. **Verify Collection Schema** - ensure required fields exist

## Error Codes Reference

- **401**: Unauthorized - check API keys and permissions
- **403**: Forbidden - check collection/bucket permissions
- **404**: Not Found - check database/collection/bucket IDs
- **409**: Conflict - check if document ID already exists
- **413**: Payload Too Large - check file size limits

## Need Help?

If you're still having issues:
1. Check the console logs for detailed error messages
2. Use the "Test Connection" button to diagnose issues
3. Verify all permissions in your Appwrite console
4. Check if your Appwrite project is on the correct plan
