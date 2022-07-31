class WeChatAuthEntry {
  /// 微信app id
  final String appId;

  /// 微信app secret
  final String appSecret;

  WeChatAuthEntry({required this.appId, required this.appSecret});

  Map<String, dynamic> toMap() {
    return {"appId": appId, "appSecret": appSecret};
  }
}
