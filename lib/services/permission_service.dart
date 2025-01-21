import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> checkPermissionStatus() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
      Permission.microphone,
    ].request();

    bool isGranted = permissions[Permission.storage]!.isGranted &&
        permissions[Permission.microphone]!.isGranted;

    if (permissions[Permission.storage]!.isPermanentlyDenied ||
        permissions[Permission.microphone]!.isPermanentlyDenied) {
      //TODO: handle permanent rejection
      openAppSettings();
    }
    debugPrint(permissions[Permission.storage]!.toString());
    debugPrint(permissions[Permission.microphone]!.toString());
    debugPrint(isGranted.toString());
    return isGranted;
  }
}
