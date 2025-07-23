package com.example.smees

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()


CoroutineScope(Dispatchers.IO).launch {
    // Initialize the Google Mobile Ads SDK on a background thread.
    MobileAds.initialize(this@MainActivity) {}
}
