import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_platform.dart';
import 'ad_unit_ids.dart';

/// 하단 내비 위에 붙는 앵커 적응형 배너.
class ShellBottomBanner extends StatefulWidget {
  const ShellBottomBanner({super.key});

  @override
  State<ShellBottomBanner> createState() => _ShellBottomBannerState();
}

class _ShellBottomBannerState extends State<ShellBottomBanner> {
  BannerAd? _banner;
  bool _loadStarted = false;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!supportsGoogleMobileAds || _loadStarted) {
      return;
    }
    _loadStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadBanner();
      }
    });
  }

  Future<void> _loadBanner() async {
    if (!mounted) {
      return;
    }
    final width = MediaQuery.sizeOf(context).width.truncate();
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (!mounted || size == null) {
      return;
    }

    final ad = BannerAd(
      adUnitId: AdUnitIds.banner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() => _loaded = true);
          }
        },
        onAdFailedToLoad: (failedAd, _) {
          failedAd.dispose();
          if (mounted) {
            setState(() {
              _banner = null;
              _loaded = false;
            });
          }
        },
      ),
    );
    setState(() => _banner = ad);
    await ad.load();
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!supportsGoogleMobileAds) {
      return const SizedBox.shrink();
    }
    final ad = _banner;
    if (ad == null || !_loaded) {
      return const SizedBox.shrink();
    }
    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}
