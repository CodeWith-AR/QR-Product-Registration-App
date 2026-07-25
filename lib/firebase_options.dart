import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS options are not configured.');
      case TargetPlatform.macOS:
        throw UnsupportedError('macOS options are not configured.');
      case TargetPlatform.windows:
        throw UnsupportedError('windows options are not configured.');
      case TargetPlatform.linux:
        throw UnsupportedError('linux options are not configured.');
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBlTXN4IyTE3NnMG8OoicR4l04P7iVCuew',
    appId: '1:223196297451:web:3ca9110d7dbb805031a6ae',
    messagingSenderId: '223196297451',
    projectId: 'authenticheck-v1-rb3554640',
    authDomain: 'authenticheck-v1-rb3554640.firebaseapp.com',
    storageBucket: 'authenticheck-v1-rb3554640.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjqqns-f4fvDp-TaOkgF6-_N2ko90Qr34',
    appId: '1:223196297451:android:14ede2fa4d9bd0e431a6ae',
    messagingSenderId: '223196297451',
    projectId: 'authenticheck-v1-rb3554640',
    storageBucket: 'authenticheck-v1-rb3554640.firebasestorage.app',
  );
}
