import 'dart:convert';
import 'dart:io';

import 'package:campus_swap/src/core/cloudinary_config.dart';
import 'package:campus_swap/src/data/storage_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late Directory tempDir;
  late File imageFile;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('storage_repo_test');
    imageFile = File('${tempDir.path}/photo.jpg')..writeAsStringSync('image-bytes');
  });

  tearDown(() => tempDir.deleteSync(recursive: true));

  StorageRepository repo(http.Client client) => StorageRepository(
    client: client,
    cloudName: 'test-cloud',
    uploadPreset: 'test-preset',
  );

  test('throws a clear error when Cloudinary is not configured', () {
    // Default placeholders => not configured; the client must never be hit.
    final repo = StorageRepository(
      client: MockClient((_) async => fail('should not send when unconfigured')),
      cloudName: CloudinaryConfig.placeholderCloudName,
      uploadPreset: CloudinaryConfig.placeholderUploadPreset,
    );
    expect(
      () => repo.uploadProfileImage(uid: 'u1', file: imageFile),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('not configured'),
        ),
      ),
    );
  });

  test('uploads to the Cloudinary endpoint and returns the secure_url', () async {
    late http.Request captured;
    final client = MockClient((request) async {
      captured = request;
      return http.Response(
        jsonEncode({'secure_url': 'https://res.cloudinary.com/test-cloud/x.jpg'}),
        200,
      );
    });

    final urls = await repo(client).uploadListingImages(
      uid: 'u1',
      listingId: 'l1',
      files: [imageFile],
    );

    expect(urls, ['https://res.cloudinary.com/test-cloud/x.jpg']);
    expect(captured.method, 'POST');
    expect(
      captured.url.toString(),
      'https://api.cloudinary.com/v1_1/test-cloud/image/upload',
    );
    // Multipart body carries the unsigned preset and the destination folder.
    expect(captured.body, contains('test-preset'));
    expect(captured.body, contains('listings/u1/l1'));
  });

  test('rejects files larger than the 5 MB cap before uploading', () async {
    var sent = false;
    final client = MockClient((_) async {
      sent = true;
      return http.Response('{}', 200);
    });
    final big = File('${tempDir.path}/big.jpg')
      ..writeAsBytesSync(List<int>.filled(CloudinaryConfig.maxBytes + 1, 0));

    await expectLater(
      () => repo(client).uploadProfileImage(uid: 'u1', file: big),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('5 MB'),
        ),
      ),
    );
    expect(sent, isFalse);
  });

  test('throws when Cloudinary returns a non-200 response', () {
    final client = MockClient((_) async => http.Response('nope', 500));
    expect(
      () => repo(client).uploadChatImage(conversationId: 'c1', file: imageFile),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('failed (500)'),
        ),
      ),
    );
  });
}
