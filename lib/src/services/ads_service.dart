// import 'package:flutter/foundation.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdsService {
//   AdsService._();

//   static final AdsService _internal = AdsService._();
//   static AdsService get instance => AdsService();

//   factory AdsService() {
//     return _internal;
//   }

//   initialize({
//     required String testAndroidBannerAdID,
//     required String testAndroidIntAdID,
//     required String androidBannerAdID,
//     required String androidInitAdID,
//     bool? testMode,
//   }) {
//     _testAndroidBannerAdID = testAndroidBannerAdID;
//     _testAndroidIntAdID = testAndroidIntAdID;
//     _androidBannerAdID = androidBannerAdID;
//     _androidInitAdID = androidInitAdID;

//     _testMode = testMode ?? _testMode;
//   }

//   String _testAndroidBannerAdID = "";
//   String _testAndroidIntAdID = "";
//   String _androidBannerAdID = "";
//   String _androidInitAdID = "";

//   bool _testMode = kDebugMode;

//   String get bannerAdUnitId =>
//       _testMode ? _testAndroidBannerAdID : _androidBannerAdID;
//   String get interAdUnitId =>
//       _testMode ? _testAndroidIntAdID : _androidInitAdID;

//   Future<BannerAd?> bannerAd({
//     AdSize size = AdSize.banner,
//     void Function(Ad ad)? onAdLoaded,
//     void Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
//     void Function(Ad ad)? onAdOpened,
//     void Function(Ad ad)? onAdClosed,
//     void Function(Ad ad)? onAdImpression,
//   }) async {
//     return BannerAd(
//       adUnitId: bannerAdUnitId,
//       request: const AdRequest(),
//       size: size,
//       listener: BannerAdListener(
//         // Called when an ad is successfully received.
//         onAdLoaded: onAdLoaded,
//         // Called when an ad request failed.
//         onAdFailedToLoad: onAdFailedToLoad,
//         // Called when an ad opens an overlay that covers the screen.
//         onAdOpened: onAdOpened,
//         // Called when an ad removes an overlay that covers the screen.
//         onAdClosed: onAdClosed,
//         // Called when an impression occurs on the ad.
//         onAdImpression: onAdImpression,
//       ),
//     );
//   }
// }
