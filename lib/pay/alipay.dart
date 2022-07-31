import 'package:eyflutter_core/eyflutter_core.dart';
import 'package:eyflutter_social/beans/alipay_entry.dart';
import 'package:eyflutter_social/enums/alipay_status.dart';

typedef AliPayCall = void Function(AliPayStatus payStatus, String response);

class AliPay {
  AliPay._();

  static String aliPayChannelName = "d9d49a7a501d9436";
  static String aliPayStatusChannelName = "0904c07a0b33d339";

  /// 支付宝支付
  /// [payEntry] 支付数据
  /// [payCall] 支付回调
  static void pay({required AliPayEntry payEntry, required AliPayCall payCall}) {
    CloudChannelManager.instance.channel?.setMethodCallHandler((call) {
      String method = call.method;
      var arguments = call.arguments;
      if (method == aliPayStatusChannelName && arguments is Map) {
        var status = arguments["status"] ?? "";
        var response = arguments["response"] ?? "";
        if (status == "processing") {
          return Future.value(null);
        }
        if (status == "success") {
          payCall(AliPayStatus.success, response);
        } else if (status == "cancel") {
          payCall(AliPayStatus.cancel, response);
        } else if (status == "disconnected") {
          payCall(AliPayStatus.disconnected, response);
        } else {
          payCall(AliPayStatus.fail, response);
        }
      }
      return Future.value(null);
    });
    CloudChannelManager.instance.send(aliPayChannelName, arguments: payEntry.toMap());
  }
}
