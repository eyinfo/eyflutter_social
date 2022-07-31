import 'package:eyflutter_core/eyflutter_core.dart';
import 'package:eyflutter_social/beans/share_info.dart';
import 'package:eyflutter_social/beans/share_properties.dart';
import 'package:eyflutter_social/configuration/fonts/cbw_fonts.dart';
import 'package:eyflutter_social/enums/share_platform.dart';
import 'package:eyflutter_social/enums/share_status.dart';
import 'package:eyflutter_social/events/on_social_config.dart';
import 'package:eyflutter_social/events/share_info_collect.dart';
import 'package:eyflutter_uikit/eyflutter_uikit.dart';
import 'package:flutter/material.dart';

typedef OnShareCancelCall = void Function();
typedef OnShareDismissCall = void Function();
typedef OnShareCall = void Function(BuildContext context, ShareInfo shareInfo, ShareStatus status);
typedef _OnItemTextIconClick = void Function(BuildContext context, dynamic extra);

class ShareWidget extends StatefulWidget {
  /// 分享组件背景颜色
  final Color backgroundColor;

  /// 分享取消
  final OnShareCancelCall? cancelCall;

  /// 分享条目事件
  final OnShareCall shareCall;

  /// true-点击组件时进行检测是否有效,false-在构建时通过包含在platforms来判断;
  /// 默认false
  final bool isClickCheck;

  /// 包含在集合内显示,否则隐藏
  final List<String> platforms;

  /// 分享信息回调
  final ShareInfoCollect? shareInfoCall;

  /// 分享销毁回调
  final OnShareDismissCall? dismissCall;

  /// 组件属性
  final ShareProperties? properties;

  final OnSocialConfig socialConfig;

  const ShareWidget({
    Key? key,
    this.backgroundColor = const Color(0xf5f7f7f7),
    this.cancelCall,
    required this.shareCall,
    this.isClickCheck = false,
    required this.platforms,
    this.shareInfoCall,
    this.dismissCall,
    this.properties,
    required this.socialConfig,
  }) : super(key: key);

  @override
  _ShareWidgetState createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {
  double itemHeight = 96;
  final String shareChannelMethodName = "1964acb974df863f";
  final String initSocialMethodName = "1f4482ba6ba89bbe";

  @override
  Widget build(BuildContext context) {
    return HorScrollView(
      backgroundColor: widget.backgroundColor,
      horDividerHeight: 1,
      horDividerColor: const Color(0xffeeeeee),
      topContainer: Container(
        color: widget.backgroundColor,
        padding: const EdgeInsets.only(left: 0, top: 12, right: 0, bottom: 12),
        alignment: Alignment.center,
        child: Text(
          widget.properties?.dialogTitle ?? "",
          maxLines: 1,
          style: const TextStyle(color: Color(0xff292929), fontSize: 14),
        ),
      ),
      children: [
        ItemViewBuilder(
          height: itemHeight,
          rowPadding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 8),
          children: [
            _buildItem(SharePlatform.weixin, _buildIcon(CbwFonts.wechat, const Color(0xff28C445)),
                widget.properties?.weiXinText ?? ""),
            _buildItem(SharePlatform.moments, _buildIcon(CbwFonts.moments, const Color(0xff28C445)),
                widget.properties?.momentsText ?? ""),
            _buildItem(
                SharePlatform.qq, _buildIcon(CbwFonts.qq, const Color(0xff46B7FF)), widget.properties?.qqText ?? ""),
            _buildItem(SharePlatform.qzone, _buildIcon(CbwFonts.qzone, const Color(0xffFDAD14)),
                widget.properties?.qZoneText ?? ""),
            _buildItem(SharePlatform.weibo, _buildIcon(CbwFonts.weibo, const Color(0xffFC5733)),
                widget.properties?.weiboText ?? ""),
          ],
        )
      ],
      bottomContainer: Container(
        margin: const EdgeInsets.only(left: 20, top: 8, right: 20, bottom: 10),
        child: TextButton(
          child: Container(
            width: double.infinity,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffE8E8ED), width: 0.8),
              borderRadius: const BorderRadius.all(Radius.circular(30)),
            ),
            child: Text(
              widget.properties?.cancelButtonText ?? "",
              style: const TextStyle(color: Color(0xff060606), fontSize: 18),
            ),
          ),
          onPressed: () {
            if (widget.cancelCall != null) {
              widget.cancelCall!();
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            minimumSize: MaterialStateProperty.all(Size.zero),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))),
          ),
        ),
      ),
    );
  }

  bool _visibilityBuildItem(SharePlatform platform) {
    return widget.platforms.contains(platform.toString().suffixName);
  }

  Widget _buildIcon(IconData iconData, Color color) {
    return Icon(
      iconData,
      size: 45,
      color: color,
    );
  }

  Widget _buildItem(SharePlatform platform, Widget child, String text) {
    return _TextIconWidget(
      extra: platform.toString().suffixName,
      isVisible: _visibilityBuildItem(platform),
      backgroundColor: widget.backgroundColor,
      drawViews: [
        Padding(
          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 8),
          child: child,
        ),
        Text(
          text,
          style: const TextStyle(color: Color(0xff3D3C3D), fontSize: 12),
        ),
      ],
      itemClick: (context, platform) {
        var shareInfo = widget.shareInfoCall?.getShareInfo(platform) ??
            ShareInfo(platform: "", channel: "", title: "", describe: "", shareType: "");
        if (shareInfo.title.isEmptyString ||
            shareInfo.platform.isEmptyString ||
            shareInfo.shareType.isEmptyString ||
            shareInfo.channel.isEmptyString) {
          return;
        }
        widget.shareCall(context, shareInfo, ShareStatus.click);
        try {
          Loadings.instance.show(context, text: widget.properties?.loadingText ?? "");
          shareInfo.platform = platform;
          CloudChannelManager.instance.send(initSocialMethodName, arguments: getInitConfig()).then((value) {
            if (value == "success") {
              CloudChannelManager.instance.send(shareChannelMethodName, arguments: shareInfo.toMap()).then((resultMap) {
                Loadings.instance.dismiss();
                if (resultMap is! Map) {
                  if (widget.dismissCall != null) {
                    widget.dismissCall!();
                  }
                  return;
                }
                if (resultMap["callType"] == "start") {
                  // 开始唤起客户端
                } else if (resultMap["callType"] == "fail") {
                  widget.shareCall(context, shareInfo, ShareStatus.fail);
                } else if (resultMap["callType"] == "cancel") {
                  widget.shareCall(context, shareInfo, ShareStatus.cancel);
                } else {
                  widget.shareCall(context, shareInfo, ShareStatus.success);
                }
                if (widget.dismissCall != null) {
                  widget.dismissCall!();
                }
              });
            }
          }, onError: (error, stack) {
            Loadings.instance.dismiss();
          });
        } catch (e) {
          Loadings.instance.dismiss();
        }
      },
    );
  }

  Map<String, dynamic> getInitConfig() {
    Map<String, dynamic> configMap = {};
    configMap["mobAppKey"] = widget.socialConfig.mobAppKey();
    configMap["mobAppSecret"] = widget.socialConfig.mobAppSecret();
    configMap["sinaAppKey"] = widget.socialConfig.sinaAppKey();
    configMap["sinaAppSecret"] = widget.socialConfig.sinaAppSecret();
    configMap["sinaRedirectUrl"] = widget.socialConfig.sinaRedirectUrl();
    configMap["wechatAppId"] = widget.socialConfig.wechatAppId();
    configMap["wechatAppSecret"] = widget.socialConfig.wechatAppSecret();
    configMap["wechatUniversalLink"] = widget.socialConfig.wechatUniversalLink();
    configMap["qqAppId"] = widget.socialConfig.qqAppId();
    configMap["qqAppKey"] = widget.socialConfig.qqAppKey();
    return configMap;
  }
}

/// 文本-图标视图
class _TextIconWidget extends StatelessWidget {
  /// 背景颜色
  final Color? backgroundColor;

  /// 扩展数据
  final dynamic extra;

  /// 条目事件
  final _OnItemTextIconClick? itemClick;

  /// 绘制视图
  final List<Widget> drawViews;

  /// 是否显示当前控件,(默认显示)
  final bool isVisible;

  const _TextIconWidget(
      {this.backgroundColor, this.extra, this.itemClick, required this.drawViews, this.isVisible = true});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !isVisible,
      child: TextButton(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 16, top: 6, right: 16, bottom: 6),
          decoration: const BoxDecoration(
            color: Color(0x117F7F7F),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: _buildViews(context),
        ),
        onPressed: () {
          if (itemClick != null) {
            itemClick!(context, extra);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          minimumSize: MaterialStateProperty.all(Size.zero),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
      ),
    );
  }

  Widget _buildViews(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: drawViews,
    );
  }
}
