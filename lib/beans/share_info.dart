import 'package:eyflutter_core/eyflutter_core.dart';

class ShareInfo {
  /// 分享平台 [SharePlatform],由分享组件内部赋值
  String platform;

  /// 分享渠道(由组件内部获取)
  String channel;

  /// 分享标题
  final String title;

  /// 分享信息
  final String describe;

  /// 分享类型[ShareType]
  final String shareType;

  /// 根据分享类型：ShareType.image-标题链接(qq该项为空),ShareType.links-分享网页url,ShareType.text-该项为空
  final String? url;

  /// 图片地址
  final String? imageUrl;

  /// 扩展数据
  final dynamic extra;

  ShareInfo({
    required this.platform,
    required this.channel,
    required this.title,
    required this.describe,
    required this.shareType,
    this.url,
    this.imageUrl,
    this.extra,
  });

  Map<String, dynamic> toMap() {
    return {
      "platform": platform,
      "channel": channel,
      "title": title,
      "describe": describe,
      "shareType": shareType,
      "url": url,
      "imageUrl": imageUrl,
      "extra": extra
    };
  }

  String toJson() {
    Map<String, dynamic> map = toMap();
    return JsonUtils.toJson(map);
  }
}
