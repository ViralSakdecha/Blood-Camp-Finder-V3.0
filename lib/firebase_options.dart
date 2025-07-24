import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError("This platform is not supported.");
    }
  }

  static final FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDQ1oxU5u73_5L-po7giP7bx_xiuqU4vyM",
    authDomain: "blood4everyone-d5f5b.firebaseapp.com",
    projectId: "blood4everyone-d5f5b",
    storageBucket: "blood4everyone-d5f5b.firebasestorage.app",
    messagingSenderId: "748322261992",
    appId: "1:748322261992:web:619df26c4f1038614f725d",
  );

  static final FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBhYz1AGmntcg8xMN1ax7b_9qH-HCiroUo",
    appId: "1:748322261992:android:7b6b32fa59c839774f725d",
    messagingSenderId: "748322261992",
    projectId: "blood4everyone-d5f5b",
    storageBucket: "blood4everyone-d5f5b.appspot.com",
  );
}
