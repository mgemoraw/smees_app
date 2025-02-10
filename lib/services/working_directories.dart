import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<Directory> createWorkingDirectory() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory workingDir = Directory('${appDir.path}/smees');

    if (!await workingDir.exists()){
        await workingDir.create(recursive:true);
    } else {
        print("Working directory already exists ${workingDir.path}");
    }

    return workingDir;
}

