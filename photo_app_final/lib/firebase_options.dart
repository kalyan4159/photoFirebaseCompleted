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
    apiKey: 'AIzaSyABH9MDDpidM5GJ8cjjrHBxkr9DYza_YwY',
    appId: '1:1026078898680:web:0b677f610768703d2bfe0d',
    messagingSenderId: '1026078898680',
    projectId: 'photoappflutter',
    authDomain: 'photoappflutter.firebaseapp.com',
    storageBucket: 'photoappflutter.appspot.com',
    measurementId: 'G-3HKLB5X8MM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDoybeZ6LRZ3LI5ViuUhSRCumJfTZ29XXg',
    appId: '1:1026078898680:android:9c3d5fb9151c3d2c2bfe0d',
    messagingSenderId: '1026078898680',
    projectId: 'photoappflutter',
    storageBucket: 'photoappflutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAmohX011tmFOsTXxZriQV3Hgnf8SfrBss',
    appId: '1:1026078898680:ios:5ae3a89b33072ab22bfe0d',
    messagingSenderId: '1026078898680',
    projectId: 'photoappflutter',
    storageBucket: 'photoappflutter.appspot.com',
    iosBundleId: 'com.example.photoAppFinal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAmohX011tmFOsTXxZriQV3Hgnf8SfrBss',
    appId: '1:1026078898680:ios:5ae3a89b33072ab22bfe0d',
    messagingSenderId: '1026078898680',
    projectId: 'photoappflutter',
    storageBucket: 'photoappflutter.appspot.com',
    iosBundleId: 'com.example.photoAppFinal',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyABH9MDDpidM5GJ8cjjrHBxkr9DYza_YwY',
    appId: '1:1026078898680:web:b7ee2674864378442bfe0d',
    messagingSenderId: '1026078898680',
    projectId: 'photoappflutter',
    authDomain: 'photoappflutter.firebaseapp.com',
    storageBucket: 'photoappflutter.appspot.com',
    measurementId: 'G-2X4XC4G3P4',
  );
}