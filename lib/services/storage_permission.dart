import 'package:permission_handler/permission_handler.dart';


Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;

    if (status.isDenied) {
        status = await Permission.storage.request();
    }

    if (status.isGranted) {
        print("Storage permission granted!");
    } else {
        print("Storage permission denied");
    }
}