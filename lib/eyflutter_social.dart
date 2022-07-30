
import 'dart:async';

import 'package:flutter/services.dart';

class EyflutterSocial {
  static const MethodChannel _channel = MethodChannel('eyflutter_social');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
