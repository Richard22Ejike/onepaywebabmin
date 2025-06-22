import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
Future<File> pickImages() async {
  File images = File('');
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,

    );
    if (files != null && files.files.isNotEmpty) {

      images=File(files.files.single.path!);

    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}

Future<void> requestPermission() async {
  PermissionStatus status = await Permission.storage.status;
  if (status.isDenied) {
    await Permission.storage.request();
  }
}


