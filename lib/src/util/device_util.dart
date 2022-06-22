import 'package:device_info_plus/device_info_plus.dart';

/// device util 设备相关工具类
class DeviceUtil {
  static final DeviceUtil instance = DeviceUtil._();
  factory DeviceUtil() => instance;
  DeviceUtil._();

  bool isPadOrTablet = false;

  Future<bool> checkIfIsPadOrTablet() async {
    bool result = false;
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final map = deviceInfo.toMap();

    if (map['model'] == 'iPad') {
      result = true;
    }
    isPadOrTablet = result;
    return result;
  }

}
