import 'package:eyflutter_core/eyflutter_core.dart';
import 'package:eyflutter_social/beans/share_info.dart';
import 'package:eyflutter_social/enums/share_platform.dart';
import 'package:eyflutter_social/enums/share_status.dart';
import 'package:eyflutter_social/events/share_info_collect.dart';
import 'package:eyflutter_social/share/share_widget.dart';
import 'package:eyflutter_uikit/eyflutter_uikit.dart';
import 'package:flutter/material.dart';

/// ShareDialog.instance.show(context,
/// platforms: [SharePlatform.weixin, SharePlatform.qq],
/// shareInfoCall: ShareInfoHandle(title: "分享测试",
/// shareType: ShareType.links, url: "https://www.baidu.com"));
class ShareDialog {
  factory ShareDialog() => _getInstance();

  static ShareDialog get instance => _getInstance();
  static ShareDialog? _instance;

  ShareDialog._internal();

  static ShareDialog _getInstance() {
    return _instance ??= ShareDialog._internal();
  }

  YYDialog? _dialog;

  /// 显示分享弹窗
  /// [context] 构建上下文
  /// [platforms] 允许展示的分享平台
  /// [shareInfoCall] 分享信息回调
  /// [title] 组件标题
  void show(BuildContext context,
      {List<SharePlatform> platforms = SharePlatform.values, ShareInfoCollect? shareInfoCall, String? title}) {
    if (!_dialog?.isShowing) {
      _dialog = YYDialog().build(context)
        ..gravity = Gravity.bottom
        ..backgroundColor = Colors.transparent
        ..barrierDismissible = false
        ..widget(_buildShareView(platforms, shareInfoCall, title ?? ""))
        ..show();
    }
  }

  Widget _buildShareView(List<SharePlatform> platforms, ShareInfoCollect? shareInfoCall, String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShareWidget(
          cancelCall: dismiss,
          shareCall: _shareClick,
          isClickCheck: true,
          platforms: _getPlatforms(platforms),
          title: title,
          shareInfoCall: shareInfoCall,
          dismissCall: () {
            dismiss();
          },
        )
      ],
    );
  }

  List<String> _getPlatforms(List<SharePlatform> platforms) {
    List<String> lst = [];
    for (var element in platforms) {
      lst.add(element.toString().suffixName);
    }
    return lst;
  }

  /// 销毁分享弹窗
  void dismiss() {
    if (_dialog?.isShowing) {
      _dialog?.dismiss();
    }
    _dialog = null;
    _instance = null;
  }

  void _shareClick(BuildContext context, ShareInfo shareInfo, ShareStatus status) {
    //这里可以添加埋点
  }
}
