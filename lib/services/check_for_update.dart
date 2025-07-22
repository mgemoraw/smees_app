import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> checkForAppUpdate() async {
  final prefs = await SharedPreferences.getInstance();
  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;

  final savedVersion = prefs.getString('app_version');

  if (savedVersion == null) {

    // First install
    print('First time install...');

  } else if (savedVersion != currentVersion) {
    // App was updated
    print('app updated from $savedVersion to $currentVersion');

    // update related logic here eg. reset cache, migrations, changelog
  }

  // Save the current version
      await prefs.setString('app_version', currentVersion);
}


