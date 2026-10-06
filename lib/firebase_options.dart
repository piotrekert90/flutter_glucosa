import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Provides the platform-specific Firebase configuration for the app.
class DefaultFirebaseOptions {
  /// Returns the Firebase configuration object for the current platform.
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Firebase configuration for the web platform.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_WEB_API_KEY',
    appId: 'REPLACE_WITH_WEB_APP_ID',
    messagingSenderId: '100228516284',
    projectId: 'glucosa-ekerstudio',
    authDomain: 'glucosa-ekerstudio.firebaseapp.com',
    storageBucket: 'glucosa-ekerstudio.firebasestorage.app',
    measurementId: 'G-REPLACE_ME',
  );

  /// Firebase configuration for Android builds.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKEWWXx_bzAGSDY1tW1R-h2e0zLqpyPl0',
    appId: '1:100228516284:android:21c77e7f3767ee361943b9',
    messagingSenderId: '100228516284',
    projectId: 'glucosa-ekerstudio',
    storageBucket: 'glucosa-ekerstudio.firebasestorage.app',
  );

  /// Firebase configuration for iOS builds.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEIz4AdOC_TKbhkI5NqY_dZqfu2GFv_k0',
    appId: '1:100228516284:ios:22286d66c921f8081943b9',
    messagingSenderId: '100228516284',
    projectId: 'glucosa-ekerstudio',
    storageBucket: 'glucosa-ekerstudio.firebasestorage.app',
    iosBundleId: 'com.ekerstudio.glucosa',
  );
}
