// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBOAmNqUS9-_QoLGmWQBf2LI0ZjGG0ij6M',
    appId: '1:767757472519:web:44100f680cff0d0a6caba2',
    messagingSenderId: '767757472519',
    projectId: 'clarity-cash',
    authDomain: 'clarity-cash.firebaseapp.com',
    storageBucket: 'clarity-cash.firebasestorage.app',
    measurementId: 'G-TJWVDQRBF9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtEobs4zsaHesLcMmDuhl8BeDzz0VizWs',
    appId: '1:767757472519:android:2478cfe3cec9d5d76caba2',
    messagingSenderId: '767757472519',
    projectId: 'clarity-cash',
    storageBucket: 'clarity-cash.firebasestorage.app',
  );
}
