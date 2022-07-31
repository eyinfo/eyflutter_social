import 'package:eyflutter_social/beans/alipay_entry.dart';
import 'package:eyflutter_social/beans/wechat_pay_entry.dart';

typedef RequestPayFailCall = void Function(String code, String message);
mixin OnRequestPayData {
  /// 根据支付订单信息请求支付数据
  Future<WechatPayEntry> requestWeChatPay(Map<String, dynamic> arguments, {RequestPayFailCall requestFailCall});

  /// 根据支付订单信息请求支付数据
  Future<AliPayEntry> requestAliPay(Map<String, dynamic> arguments, {RequestPayFailCall requestFailCall});
}
