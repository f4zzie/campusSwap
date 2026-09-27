import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageRepository {
  StorageRepository(this._storage);

  final FirebaseStorage _storage;
  final _uuid = const Uuid();

  Future<List<String>> uploadListingImages({
    required String uid,
    required String listingId,
    required List<File> files,
  }) async {
    final urls = <String>[];
    for (final file in files) {
      final ref = _storage.ref(
        'listings/$uid/$listingId/${_uuid.v4()}.${_extension(file)}',
      );
      await ref.putFile(file, _metadataFor(file));
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  Future<String> uploadChatImage({
    required String conversationId,
    required File file,
  }) async {
    final ref = _storage.ref(
      'chat_images/$conversationId/${_uuid.v4()}.${_extension(file)}',
    );
    await ref.putFile(file, _metadataFor(file));
    return ref.getDownloadURL();
  }

  Future<String> uploadProfileImage({
    required String uid,
    required File file,
  }) async {
    final ref = _storage.ref(
      'profile_images/$uid/${_uuid.v4()}.${_extension(file)}',
    );
    await ref.putFile(file, _metadataFor(file));
    return ref.getDownloadURL();
  }

  String _extension(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    return ext == 'jpg' ? 'jpeg' : ext;
  }

  SettableMetadata _metadataFor(File file) =>
      SettableMetadata(contentType: 'image/${_extension(file)}');
}
