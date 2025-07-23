import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform; // Import for Platform.isAndroid

class BannerExample extends StatefulWidget {
  const BannerExample({super.key});

  @override
  State<BannerExample> createState() => BannerExampleState();
}

class BannerExampleState extends State<BannerExample> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // TODO: replace this test ad unit with your own ad unit.
  final String adUnitId = Platform.isAndroid
      // ? 'ca-app-pub-3523265451349209/5982594969' // smees ad unit
      ? 'ca-app-pub-3940256099942544/9214589741' // Android test ad unit
      : 'ca-app-pub-3940256099942544/2435281174'; // iOS test ad unit

  @override
  void initState() {
    super.initState();
    loadAd(); // Load the ad when the widget initializes
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // Dispose the ad when the widget is removed
    super.dispose();
  }

  /// Loads a banner ad.
  void loadAd() async {
    // Ensure the widget is mounted before accessing MediaQuery.
    if (!mounted) return;

    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    // We use MediaQuery.of(context).size.width to get the current screen width.
    final AdSize? size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      debugPrint('Unable to get an anchored adaptive banner size.');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err'); // Use $err for the error object
          // Dispose the ad here to free resources.
          ad.dispose();
          setState(() {
            _isLoaded = false; // Set to false if ad fails to load
          });
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    );
    // Load the ad. This is an asynchronous operation.
    await _bannerAd?.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdMob Banner Example'),
      ),
      body: Center(
        child: _isLoaded && _bannerAd != null
            ? SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        )
            : const Text('Loading Ad...'), // Display a loading message
      ),
      // Optionally, you can place the banner at the bottom using a Column or Align widget
      bottomNavigationBar: _isLoaded && _bannerAd != null
          ? SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      )
          : null, // Don't show anything if ad not loaded
    );
  }
}