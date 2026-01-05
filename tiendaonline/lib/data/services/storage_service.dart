import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  Future<String> uploadImage(File file, {String folder = 'products'}) async {
    final fileName = '${_uuid.v4()}.jpg';
    final ref = _storage.ref().child('$folder/$fileName');

    final snapshot = await ref.putFile(file);
    return await snapshot.ref.getDownloadURL();
  }
}
