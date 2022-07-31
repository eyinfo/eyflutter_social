class WeiBoAuthEntry {
  /// 新浪微博app key
  final String appKey;

  /// 新浪微博app secret
  final String appSecret;

  /// 新浪微博结果回调地址
  final String? redirectUrl;

  WeiBoAuthEntry({required this.appKey, required this.appSecret, this.redirectUrl});

  Map<String, dynamic> toMap() {
    return {"appKey": appKey, "appSecret": appSecret, "redirectUrl": redirectUrl};
  }
}
