// Android: android/app/google-services.json 과 동일 프로젝트.
// iOS·Web 등은 Firebase 콘솔에 앱을 추가한 뒤 `flutterfire configure`로 덮어쓰는 것을 권장합니다.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Android `mobilesdk_app_id` — google-services.json 과 동일해야 합니다.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDCQB2fiNddCH3NlNSbTrjhqwTaxOczEMo',
    appId: '1:597361891322:android:1ecb4d15798906884af643',
    messagingSenderId: '597361891322',
    projectId: 'mybrainhealth',
    storageBucket: 'mybrainhealth.firebasestorage.app',
  );

  /// Web 앱을 Firebase 콘솔에 등록한 뒤 appId 등을 교체하세요.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDCQB2fiNddCH3NlNSbTrjhqwTaxOczEMo',
    appId: '1:597361891322:web:configureInFirebaseConsole0001',
    messagingSenderId: '597361891322',
    projectId: 'mybrainhealth',
    authDomain: 'mybrainhealth.firebaseapp.com',
    storageBucket: 'mybrainhealth.firebasestorage.app',
  );

  /// iOS 앱 등록 후 flutterfire configure 권장.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCQB2fiNddCH3NlNSbTrjhqwTaxOczEMo',
    appId: '1:597361891322:ios:configureInFirebaseConsole0001',
    messagingSenderId: '597361891322',
    projectId: 'mybrainhealth',
    storageBucket: 'mybrainhealth.firebasestorage.app',
    iosBundleId: 'com.parker.mybrainhealth',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCQB2fiNddCH3NlNSbTrjhqwTaxOczEMo',
    appId: '1:597361891322:ios:configureInFirebaseConsole0001',
    messagingSenderId: '597361891322',
    projectId: 'mybrainhealth',
    storageBucket: 'mybrainhealth.firebasestorage.app',
    iosBundleId: 'com.parker.mybrainhealth',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDCQB2fiNddCH3NlNSbTrjhqwTaxOczEMo',
    appId: '1:597361891322:web:configureInFirebaseConsole0001',
    messagingSenderId: '597361891322',
    projectId: 'mybrainhealth',
    authDomain: 'mybrainhealth.firebaseapp.com',
    storageBucket: 'mybrainhealth.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyDCQB2fiNddCH3NlNSbTrjhqwTaxOczEMo',
    appId: '1:597361891322:web:configureInFirebaseConsole0001',
    messagingSenderId: '597361891322',
    projectId: 'mybrainhealth',
    authDomain: 'mybrainhealth.firebaseapp.com',
    storageBucket: 'mybrainhealth.firebasestorage.app',
  );
}
