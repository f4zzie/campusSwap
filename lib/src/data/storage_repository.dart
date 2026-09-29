import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../core/cloudinary_config.dart';

/// Uploads images to Cloudinary (free tier) and returns their public URLs.
///
/// The app persists only the returned URL — in a listing's `imageUrls`, a
/// message's `imageUrl`, or a profile's `photoUrl` — and renders it with
/// `CachedNetworkImage`, so the host is an implementation detail hidden behind
/// this class. See [CloudinaryConfig] for the one-time account setup.
class StorageRepository {
  StorageRepository({
    http.Client? client,
    String? cloudName,
    String? uploadPreset,
  }) : _client = client ?? http.Client(),
       _cloudName = cloudName ?? CloudinaryConfig.cloudName,
       _uploadPreset = uploadPreset ?? CloudinaryConfig.uploadPreset;

  final http.Client _client;
  final String _cloudName;
  final String _uploadPreset;

  Future<List<String>> uploadListingImages({
    required String uid,
    required String listingId,
    required List<File> files,
  }) async {
    final urls = <String>[];
    for (final file in files) {
      urls.add(await _upload(file, folder: 'listings/$uid/$listingId'));
    }
    return urls;
  }

  Future<String> uploadChatImage({
    required String conversationId,
    required File file,
  }) => _upload(file, folder: 'chat_images/$conversationId');

  Future<String> uploadProfileImage({required String uid, required File file}) =>
      _upload(file, folder: 'profile_images/$uid');

  /// Sends one file to Cloudinary's unsigned upload endpoint and returns its
  /// `secure_url`. [folder] keeps the media library organised the same way the
  /// old Storage paths were.
  Future<String> _upload(File file, {required String folder}) async {
    if (_cloudName == CloudinaryConfig.placeholderCloudName ||
        _uploadPreset == CloudinaryConfig.placeholderUploadPreset) {
      throw StateError(
        'Cloudinary is not configured — set cloudName and uploadPreset in '
        'lib/src/core/cloudinary_config.dart.',
      );
    }
    final length = await file.length();
    if (length > CloudinaryConfig.maxBytes) {
      throw StateError('Images must be 5 MB or smaller.');
    }

    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..fields['folder'] = folder
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await http.Response.fromStream(await _client.send(request));
    if (response.statusCode != 200) {
      throw StateError(
        'Image upload failed (${response.statusCode}). Please try again.',
      );
    }
    final url = (jsonDecode(response.body) as Map<String, dynamic>)['secure_url'];
    if (url is! String) {
      throw StateError('Image upload returned no URL.');
    }
    return url;
  }
}
