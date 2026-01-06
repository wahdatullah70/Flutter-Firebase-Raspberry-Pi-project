import 'dart:typed_data';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFilePath(String path, String filePath) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putFile(File(filePath));
      return await ref.getDownloadURL();
    } catch (e) {
      developer.log('Upload error', name: 'StorageService', error: e);
      return null;
    }
  }

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

  Future<String?> downloadFile(String path, String localPath) async {
    try {
      final ref = _storage.ref().child(path);
      final file = File(localPath);
      await ref.writeToFile(file);
      return localPath;
    } catch (e) {
      developer.log('Download error', name: 'StorageService', error: e);
      return null;
    }
  }
}
