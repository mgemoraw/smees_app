import 'package:in_app_update/in_app_update.dart';
import 'package:version/version.dart'; // If using for advanced version comparisons
import 'package:flutter/material.dart';


// Global variable or part of a state management solution to track update info
AppUpdateInfo? _updateInfo;

Future<void> checkInAppUpdate() async {
  try {
    // Check for update availability
    _updateInfo = await InAppUpdate.checkForUpdate();

    if (_updateInfo?.flexibleUpdateAllowed == true) {
      // You can also check _updateInfo.updateAvailability for more details:
      // - UpdateAvailability.UPDATE_AVAILABLE
      // - UpdateAvailability.UPDATE_NOT_AVAILABLE
      // - UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS

      // Determine update type based on priority (if you control it from backend)
      // For example, if your backend indicates a "critical" update:
      // bool isCriticalUpdate = fetchIsCriticalUpdateFromBackend(); // Your backend logic
      // if (isCriticalUpdate && (_updateInfo?.immediateUpdateAllowed == true)) {
      //   // Initiate immediate update flow
      //   _startImmediateUpdateFlow();
      // } else if (_updateInfo?.flexibleUpdateAllowed == true) {
      //   // Initiate flexible update flow
      //   _startFlexibleUpdateFlow();
      // }

      // Simplified approach: Prefer Flexible, fallback to Immediate if necessary
      if (_updateInfo?.flexibleUpdateAllowed == true) {
        _startFlexibleUpdateFlow();
      } else if (_updateInfo?.immediateUpdateAllowed == true) {
        _startImmediateUpdateFlow();
      }
    } else {
      print('No in-app update available.');
    }
  } catch (e) {
    print('Error checking for in-app update: $e');
    // Handle specific errors, e.g., API_NOT_AVAILABLE if not installed from Play Store
    // or if the device doesn't support Play Core.
    // This is where your fallback to the general app store link (from previous answer)
    // might be useful for devices not supporting in-app updates.
  }
}

// Function for Flexible Update Flow
Future<void> _startFlexibleUpdateFlow() async {
  print('Starting flexible update flow...');
  try {
    // Start downloading the update in the background
    final result = await InAppUpdate.startFlexibleUpdate();

    if (result == AppUpdateResult.success) {
      // Update downloaded, now prompt the user to install
      _showFlexibleUpdateReadyDialog();
    } else {
      print('Flexible update failed or was cancelled: $result');
      // Handle cancellation or failure
    }
  } catch (e) {
    print('Error during flexible update: $e');
  }
}

// Dialog to prompt user to install flexible update
void _showFlexibleUpdateReadyDialog() {
  showDialog(
    context: navigatorKey.currentContext!, // Use a GlobalKey for Navigator if calling outside widget build context
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Update Ready!'),
        content: const Text('A new version of the app has been downloaded. Restart now to apply the update?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Later'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Restart & Install'),
            onPressed: () async {
              Navigator.of(context).pop();
              await InAppUpdate.completeFlexibleUpdate(); // This will restart the app
            },
          ),
        ],
      );
    },
  );
}

// Function for Immediate Update Flow
Future<void> _startImmediateUpdateFlow() async {
  print('Starting immediate update flow...');
  try {
    final result = await InAppUpdate.performImmediateUpdate();
    if (result == AppUpdateResult.success) {
      print('Immediate update successful!');
      // App will restart automatically after successful immediate update
    } else {
      print('Immediate update failed or was cancelled: $result');
      // If user cancelled, you might want to show a message or prevent further use
      // based on your app's criticality.
    }
  } catch (e) {
    print('Error during immediate update: $e');
  }
}

// It's good practice to have a global navigator key if you need to show dialogs
// from outside a widget's build context (e.g., from initState or a service).
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// In your MaterialApp
// MaterialApp(
//   navigatorKey: navigatorKey,
//   home: MyAppHome(),
// );