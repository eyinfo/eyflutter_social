import 'package:eyflutter_core/eyflutter_core.dart';
import 'package:eyflutter_social/events/social_config_event.dart';

class SocialManager {
  factory SocialManager() => _getInstance();

  static SocialManager get instance => _getInstance();
  static SocialManager? _instance;

  SocialManager._internal();

  static SocialManager _getInstance() {
    return _instance ??= SocialManager._internal();
  }

  final String _configKey = "5455e32f473f449fb458969680bd7681";

  /// 设置分享、授权配置
  /// [configEvent] 配置实现对象
  void setting(SocialConfigEvent configEvent) {
    ConfigManager.instance.addConfig(_configKey, configEvent);
  }

  /// 获取分享、授权配置信息
  SocialConfigEvent get configInfo => ConfigManager.instance.getConfig(_configKey);
}
