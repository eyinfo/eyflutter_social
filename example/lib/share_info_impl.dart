import 'package:eyflutter_core/eyflutter_core.dart';
import 'package:eyflutter_social/eyflutter_social.dart';

class ShareInfoImpl with ShareInfoCollect {
  /// 分享标题
  final String title;

  /// 分享信息
  final String? describe;

  final ShareType shareType;

  /// 根据分享类型：ShareType.image-标题链接(qq该项为空),ShareType.links-分享网页url,ShareType.text-该项为空
  final String? url;

  /// 图片地址
  final String? imageUrl;

  /// 扩展数据
  final dynamic extra;

  /// 应用渠道
  final String? channel;

  ShareInfoImpl({
    required this.title,
    this.describe,
    required this.shareType,
    this.url,
    this.imageUrl,
    this.extra,
    this.channel,
  });

  @override
  ShareInfo getShareInfo(String platform) {
    return ShareInfo(
      platform: platform,
      channel: channel ?? "",
      title: title,
      describe: describe ?? "",
      shareType: shareType.toString().suffixName,
      url: url,
      imageUrl: imageUrl,
      extra: extra,
    );
  }
}
