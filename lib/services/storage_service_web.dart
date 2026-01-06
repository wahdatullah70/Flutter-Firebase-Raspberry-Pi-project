import 'dart:typed_data';

import 'dart:developer' as developer;

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadBytes(String path, Uint8List bytes, {String? contentType}) async {
    try {
      final ref = _storage.ref().child(path);
      final metadata = contentType != null ? SettableMetadata(contentType: contentType) : null;
      await ref.putData(bytes, metadata);
      return await ref.getDownloadURL();
    } catch (e) {
      developer.log('Upload error', name: 'StorageService', error: e);
      return null;
    }
  }

  Future<String?> uploadFilePath(String path, String filePath) async {
    throw UnsupportedError('uploadFilePath is not supported on web. Use uploadBytes instead.');
  }

  Future<String?> downloadFile(String path, String localPath) async {
    throw UnsupportedError('downloadFile is not supported on web. Use getDownloadURL and browser download instead.');
  }
}
