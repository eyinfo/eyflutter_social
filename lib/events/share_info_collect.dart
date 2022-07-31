import 'package:eyflutter_social/beans/share_info.dart';

/// 分享信息收集
mixin ShareInfoCollect {
  /// 获取分享信息
  /// [platform] 分享平台
  ShareInfo getShareInfo(String platform);
}
