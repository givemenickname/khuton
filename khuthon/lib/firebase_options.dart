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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyC3Oah2zR7Rtr_H7zW6blE7w7bclooqVXo',
    appId: '1:612300351766:web:422d224a0410024a9c4837',
    messagingSenderId: '612300351766',
    projectId: 'khuthon-ff826',
    authDomain: 'khuthon-ff826.firebaseapp.com',
    storageBucket: 'khuthon-ff826.firebasestorage.app',
    measurementId: 'G-L32DS9LGME',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCKSeT1utCVR7exOwEP10ogUUdVgxqjnhY',
    appId: '1:612300351766:android:e96ab2eec90bc7fe9c4837',
    messagingSenderId: '612300351766',
    projectId: 'khuthon-ff826',
    storageBucket: 'khuthon-ff826.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFjOu1IDoCea8VlusV3lFVVS5Fo8j7ofM',
    appId: '1:612300351766:ios:3e980512161c59d69c4837',
    messagingSenderId: '612300351766',
    projectId: 'khuthon-ff826',
    storageBucket: 'khuthon-ff826.firebasestorage.app',
    iosBundleId: 'com.example.khuthon',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDFjOu1IDoCea8VlusV3lFVVS5Fo8j7ofM',
    appId: '1:612300351766:ios:3e980512161c59d69c4837',
    messagingSenderId: '612300351766',
    projectId: 'khuthon-ff826',
    storageBucket: 'khuthon-ff826.firebasestorage.app',
    iosBundleId: 'com.example.khuthon',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC3Oah2zR7Rtr_H7zW6blE7w7bclooqVXo',
    appId: '1:612300351766:web:bcd5feee0f4a5e379c4837',
    messagingSenderId: '612300351766',
    projectId: 'khuthon-ff826',
    authDomain: 'khuthon-ff826.firebaseapp.com',
    storageBucket: 'khuthon-ff826.firebasestorage.app',
    measurementId: 'G-BM8RSMM7YP',
  );

}