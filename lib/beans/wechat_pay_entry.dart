class WechatPayEntry {
  /// 微信app id
  String appId;

  ///与开放平台保持一致(目前仅ios用到)
  String? universalLink;

  /// 支付商户id
  final String partnerId;

  /// 预支付id(一般指订单id)
  final String prepayId;

  /// 支付随机码
  final String nonceStr;

  /// 当前时间戳(一般由接口返回)
  final String timestamp;

  /// 签名信息
  final String sign;

  WechatPayEntry(
      {required this.appId,
      this.universalLink,
      required this.partnerId,
      required this.prepayId,
      required this.nonceStr,
      required this.timestamp,
      required this.sign});

  Map<String, dynamic> toMap() {
    Map<String, Object> map = {};
    map["appId"] = appId;
    map["partnerId"] = partnerId;
    map["prepayId"] = prepayId;
    map["nonceStr"] = nonceStr;
    map["timestamp"] = timestamp;
    map["sign"] = sign;
    return map;
  }
}
