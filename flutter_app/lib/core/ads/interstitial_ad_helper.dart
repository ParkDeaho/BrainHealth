import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_platform.dart';
import 'ad_unit_ids.dart';

/// 전면광고 1개를 미리 로드하고, 필요 시 표시합니다.
///
/// 에뮬/디버그 검증은 Google 테스트 단위 ID 사용을 권장합니다.
/// https://developers.google.com/admob/android/test-ads
class InterstitialAdHelper {
  InterstitialAdHelper._();

  static final InterstitialAdHelper instance = InterstitialAdHelper._();

  InterstitialAd? _ad;
  bool _loading = false;

  bool get hasAdReady => _ad != null;

  /// 다음 전면을 미리 받습니다. 앱 시작 시 한 번 호출하면 됩니다.
  Future<void> prepare() async {
    if (!supportsGoogleMobileAds || _ad != null || _loading) {
      return;
    }
    _loading = true;
    await InterstitialAd.load(
      adUnitId: AdUnitIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loading = false;
          _ad = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (a) {
              a.dispose();
              _ad = null;
              prepare();
            },
            onAdFailedToShowFullScreenContent: (a, _) {
              a.dispose();
              _ad = null;
              prepare();
            },
          );
        },
        onAdFailedToLoad: (_) {
          _loading = false;
        },
      ),
    );
  }

  /// 로드된 전면이 있으면 표시하고 `true`, 없으면 `false`.
  bool showIfReady() {
    if (!supportsGoogleMobileAds) {
      return false;
    }
    final ad = _ad;
    if (ad == null) {
      prepare();
      return false;
    }
    ad.show();
    _ad = null;
    return true;
  }
}
