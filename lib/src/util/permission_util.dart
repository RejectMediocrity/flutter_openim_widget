import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  PermissionUtil._();

  static void camera(Function() onGranted,
      {Function(PermissionStatus)? onFailed}) async {
    try {
      PermissionStatus status = await p.Permission.camera.request();
      if (status.isGranted) {
        // Either the permission was already granted before or the user just granted it.
        onGranted();
      } else {
        if (onFailed != null) onFailed(status);
      }
      if (await p.Permission.camera.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
      }
    } catch (e) {
      if (onFailed != null) onFailed(p.PermissionStatus.permanentlyDenied);
    }
  }

  static void storage(Function() onGranted,
      {Function(PermissionStatus)? onFailed}) async {
    try {
      PermissionStatus status = await p.Permission.storage.request();
      if (status.isGranted) {
        // Either the permission was already granted before or the user just granted it.
        onGranted();
      } else {
        if (onFailed != null) onFailed(status);
      }
      if (await p.Permission.storage.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
      }
    } catch (e) {
      if (onFailed != null) onFailed(p.PermissionStatus.permanentlyDenied);
    }
  }

  static void microphone(Function() onGranted,
      {Function(PermissionStatus)? onFailed, Function()? onPermanently}) async {
    try {
      PermissionStatus status = await p.Permission.microphone.request();
      if (status.isGranted) {
        // Either the permission was already granted before or the user just granted it.
        onGranted();
      } else if (status.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
        onPermanently?.call();
      } else {
        if (onFailed != null) onFailed(status);
      }
    } catch (e) {
      if (onFailed != null) onFailed(p.PermissionStatus.permanentlyDenied);
    }
  }

  static void location(Function() onGranted,
      {Function(PermissionStatus)? onFailed}) async {
    try {
      PermissionStatus status = await p.Permission.location.request();
      if (status.isGranted) {
        // Either the permission was already granted before or the user just granted it.
        onGranted();
      } else {
        if (onFailed != null) onFailed(status);
      }
      if (await p.Permission.location.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
      }
    } catch (e) {
      if (onFailed != null) onFailed(p.PermissionStatus.permanentlyDenied);
    }
  }

  static void speech(Function() onGranted,
      {Function(PermissionStatus)? onFailed}) async {
    try {
      PermissionStatus status = await p.Permission.speech.request();
      if (status.isGranted) {
        // Either the permission was already granted before or the user just granted it.
        onGranted();
      } else {
        if (onFailed != null) onFailed(status);
      }
      if (await p.Permission.speech.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
      }
    } catch (e) {
      if (onFailed != null) onFailed(p.PermissionStatus.permanentlyDenied);
    }
  }

  static void photos(Function() onGranted,
      {Function(PermissionStatus)? onFailed}) async {
    try {
      PermissionStatus status = await p.Permission.photos.request();
      if (status.isGranted) {
        // Either the permission was already granted before or the user just granted it.
        onGranted();
      } else {
        if (onFailed != null) onFailed(status);
      }
      if (await p.Permission.photos.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
      }
    } catch (e) {
      if (onFailed != null) onFailed(p.PermissionStatus.permanentlyDenied);
    }
  }

  static Future<Map<Permission, PermissionStatus>> request(
      List<Permission> permissions) async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    return statuses;
  }
}
