import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/brain_train_app.dart';
import 'core/ads/ad_platform.dart';
import 'core/ads/interstitial_ad_helper.dart';
import 'firebase_options.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    debugPrint('Firebase.initializeApp failed: $e');
    if (kDebugMode) {
      debugPrintStack(stackTrace: st);
    }
  }

  if (supportsGoogleMobileAds) {
    await MobileAds.instance.initialize();
    unawaited(InterstitialAdHelper.instance.prepare());
  }

  runApp(
    const ProviderScope(
      child: BrainTrainApp(),
    ),
  );
}
