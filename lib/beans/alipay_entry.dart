class AliPayEntry {
  /// 签名信息(实际项目中只需要此字段，其它数据根据需要接收)
  final String sign;

  /// 应用scheme(目前仅ios用于唤起app接收支付回调)
  String appScheme;

  AliPayEntry({required this.sign, required this.appScheme});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["sign"] = sign;
    map["appScheme"] = appScheme;
    return map;
  }
}
