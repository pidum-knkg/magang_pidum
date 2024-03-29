// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAhx0UnRzXcOqRkRqdtI1aFVuZYTAnZcY8',
    appId: '1:618105289905:web:aa5635895528469ce33690',
    messagingSenderId: '618105289905',
    projectId: 'pidum-37a51',
    authDomain: 'pidum-37a51.firebaseapp.com',
    storageBucket: 'pidum-37a51.appspot.com',
    measurementId: 'G-HMBMGX3CX4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdubQzYVEDuY4CB2igAfa0OkR00TW9Xd0',
    appId: '1:618105289905:android:44b057a49e219449e33690',
    messagingSenderId: '618105289905',
    projectId: 'pidum-37a51',
    storageBucket: 'pidum-37a51.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMCLYVUljhIs5Tzg_GO4jfP1vTquDRY18',
    appId: '1:618105289905:ios:5b945b0562b0e4f4e33690',
    messagingSenderId: '618105289905',
    projectId: 'pidum-37a51',
    storageBucket: 'pidum-37a51.appspot.com',
    iosBundleId: 'com.example.magangPidum',
  );
}
