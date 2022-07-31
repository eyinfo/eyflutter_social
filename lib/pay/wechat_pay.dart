import 'package:eyflutter_core/eyflutter_core.dart';
import 'package:eyflutter_social/beans/wechat_pay_entry.dart';
import 'package:eyflutter_social/enums/wechat_pay_status.dart';

typedef WechatPayCall = void Function(WechatPayStatus payStatus, String message);

class WechatPay {
  WechatPay._();

  static String wechatPayParamsChannelName = "62d478aa6f121ac2";
  static String wechatPayChannelName = "7144a3ab855396d9";
  static String wechatPayResponseChannelName = "a48409d9f8520605";

  /// 微信支付
  /// [payEntry] 支付信息
  /// [payCall] 支付回调
  static void pay({required WechatPayEntry payEntry, required WechatPayCall payCall}) {
    CloudChannelManager.instance.send(wechatPayParamsChannelName,
        arguments: {"appId": payEntry.appId, "universalLink": payEntry.universalLink}).then((value) {
      if (value == "success") {
        CloudChannelManager.instance.channel?.setMethodCallHandler((call) {
          String method = call.method;
          if (method == wechatPayResponseChannelName && call.arguments is Map) {
            var arguments = call.arguments;
            var status = arguments["status"];
            var response = arguments["response"];
            if (status == "wx_pay_success") {
              payCall(WechatPayStatus.success, response);
            } else if (status == "wx_pay_cancel") {
              payCall(WechatPayStatus.cancel, response);
            } else {
              payCall(WechatPayStatus.fail, response);
            }
          }
          return Future.value(null);
        });
        CloudChannelManager.instance.send(wechatPayChannelName, arguments: payEntry.toMap());
      }
    });
  }
}
