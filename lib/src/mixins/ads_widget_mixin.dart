import 'package:agradiance_flutter_drive/src/services/ads_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

mixin AdsWidgetMixin<T extends StatefulWidget> on State<T> {
  InterstitialAd? _interstitialAd;
  InterstitialAd? get interstitialAd => _interstitialAd;
  set interstitialAd(InterstitialAd? value) => _interstitialAd = value;

  final ValueNotifier<bool> _isInterstitialAdLoaded = ValueNotifier(false);
  bool get isInterstitialAdLoaded => _isInterstitialAdLoaded.value;
  set isInterstitialAdLoaded(bool value) => _isInterstitialAdLoaded.value = value;

  BannerAd? _bannerAd;
  BannerAd? get bannerAd => _bannerAd;
  set bannerAd(BannerAd? value) => _bannerAd = value;

  final ValueNotifier<bool> _isBannerLoaded = ValueNotifier(false);
  bool get isBannerLoaded => _isBannerLoaded.value;
  set isBannerLoaded(bool value) => _isBannerLoaded.value = value;

  @override
  void initState() {
    super.initState();
    // loadBannerAd();  let this be loaded in the widgets
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Widget buildBannerWidget() {
    if (isBannerLoaded && bannerAd != null) {
      return SizedBox(
        width: bannerAd!.size.width.toDouble(),
        height: bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: bannerAd!),
      );
    }
    return SizedBox.shrink();
  }

  void loadBannerAd() async {
    final adsService = AdsService.instance;

    bannerAd = await adsService.bannerAd(
      onAdLoaded: (ad) {
        //
        //dprint('$ad loaded.');
        setState(() {
          isBannerLoaded = true;
        });
      },
      onAdFailedToLoad: (ad, error) {
        //
        //dprint('BannerAd failed to load: $error');
        setState(() {
          isBannerLoaded = false;
        });
        // Dispose the ad here to free resources.
        ad.dispose();
      },
    );

    await bannerAd?.load();

    setState(() {});

    // _bannerAd?.load();
  }

  Future<void> loadInterstitialAd() async {
    // if (isInterstitialAdLoaded) {
    //   return;
    // }
    await InterstitialAd.load(
      adUnitId: AdsService.instance.interAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
            onAdShowedFullScreenContent: (ad) {},
            // Called when an impression occurs on the ad.
            onAdImpression: (ad) {},
            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) async {
              // Dispose the ad here to free resources.
              ad.dispose();
              setState(() {
                _interstitialAd = null;
                _isInterstitialAdLoaded.value = false;
              });
              await loadInterstitialAd();
            },
            // Called when a click is recorded for an ad.
            onAdClicked: (ad) {},
          );

          //dprint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          //dprint('InterstitialAd failed to load: $error');
          _interstitialAd?.dispose();
          setState(() {
            _interstitialAd = null;
            _isInterstitialAdLoaded.value = false;
          });
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    // _interstitialAd = null;
    if (_interstitialAd != null) {
      await _interstitialAd?.show();
    } else {
      await loadInterstitialAd();

      if (_interstitialAd != null) {
        await _interstitialAd?.show();
      }
    }
  }
}
