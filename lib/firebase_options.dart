// Firebase options — projeto atlas-160cf (Android).
// Para outras plataformas: flutterfire configure

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase Web não configurado. Execute flutterfire configure.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'Firebase iOS não configurado. Execute flutterfire configure.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'Firebase macOS não configurado. Execute flutterfire configure.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Firebase Windows não configurado. Execute flutterfire configure.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Firebase Linux não é suportado neste projeto.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não suportado nesta plataforma.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1kskOdPVmk1DmihTzMcSeUtZH1zhSkQw',
    appId: '1:619194088679:android:6811620590b6fbfee9b642',
    messagingSenderId: '619194088679',
    projectId: 'atlas-160cf',
    storageBucket: 'atlas-160cf.firebasestorage.app',
  );
}
