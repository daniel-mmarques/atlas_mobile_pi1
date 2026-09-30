import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ProfileMediaUploader {
  ProfileMediaUploader({
    FirebaseStorage? storage,
    ImagePicker? picker,
  })  : _storage = storage ?? FirebaseStorage.instance,
        _picker = picker ?? ImagePicker();

  final FirebaseStorage _storage;
  final ImagePicker _picker;

  Future<XFile?> pickImage({
    double maxWidth = 1600,
    double maxHeight = 1600,
  }) {
    return _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: 85,
    );
  }

  Future<String> upload({
    required String uid,
    required XFile file,
    required String fileName,
  }) async {
    final ref = _storage.ref().child('users/$uid/$fileName');
    final metadata = SettableMetadata(contentType: 'image/jpeg');

    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      await ref.putData(bytes, metadata);
    } else {
      await ref.putFile(File(file.path), metadata);
    }

    return ref.getDownloadURL();
  }

  Future<String> uploadBanner({
    required String uid,
    required XFile file,
  }) =>
      upload(uid: uid, file: file, fileName: 'banner.jpg');

  Future<String> uploadAvatar({
    required String uid,
    required XFile file,
  }) =>
      upload(uid: uid, file: file, fileName: 'avatar.jpg');
}

/// Alias legado usado pelo fluxo de banner.
typedef ProfileBannerUploader = ProfileMediaUploader;
