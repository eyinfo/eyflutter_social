import 'package:eyflutter_social/beans/alipay_entry.dart';
import 'package:eyflutter_social/beans/wechat_pay_entry.dart';
import 'package:eyflutter_social/enums/alipay_status.dart';
import 'package:eyflutter_social/enums/pay_status.dart';
import 'package:eyflutter_social/enums/pay_type.dart';
import 'package:eyflutter_social/enums/wechat_pay_status.dart';
import 'package:eyflutter_social/pay/alipay.dart';
import 'package:eyflutter_social/pay/wechat_pay.dart';

typedef PayCall = void Function(PayStatus payStatus, String message);

class PayUtils {
  PayUtils._();

  /// 微信、支付宝支付
  /// [payType] 支付类型
  /// [payEntry] 支付数据：
  /// 当payType==PayType.weChat时为[WechatPayEntry]
  /// 当payType==PayType.aliPay时为[AliPayEntry]
  /// [payCall] 支付回调
  static void pay({required PayType payType, dynamic payEntry, required PayCall payCall}) {
    if (payType == PayType.weChat && payEntry is WechatPayEntry) {
      WechatPay.pay(
          payEntry: payEntry,
          payCall: (payStatus, message) {
            if (payStatus == WechatPayStatus.success) {
              payCall(PayStatus.success, message);
            } else if (payStatus == WechatPayStatus.cancel) {
              payCall(PayStatus.cancel, message);
            } else {
              payCall(PayStatus.fail, message);
            }
          });
    } else if (payType == PayType.aliPay && payEntry is AliPayEntry) {
      AliPay.pay(
          payEntry: payEntry,
          payCall: (payStatus, response) {
            if (payStatus == AliPayStatus.success) {
              payCall(PayStatus.success, response);
            } else if (payStatus == AliPayStatus.cancel) {
              payCall(PayStatus.cancel, response);
            } else {
              payCall(PayStatus.fail, response);
            }
          });
    }
  }
}
