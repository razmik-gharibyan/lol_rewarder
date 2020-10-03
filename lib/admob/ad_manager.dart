import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "<ca-app-pub-8371067774687611~8302101663>";
    } else if (Platform.isIOS) {
      return "<ca-app-pub-8371067774687611~4623722864>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "<ca-app-pub-8371067774687611/2481114567>";
    } else if (Platform.isIOS) {
      return "<ca-app-pub-8371067774687611/1443365061>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "<ca-app-pub-8371067774687611/8200345106>";
    } else if (Platform.isIOS) {
      return "<ca-app-pub-8371067774687611/7817201720>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "<YOUR_ANDROID_REWARDED_AD_UNIT_ID>";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_REWARDED_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}