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

 Add Yours
