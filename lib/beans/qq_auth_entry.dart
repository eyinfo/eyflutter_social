class QQAuthEntry {
  /// qq app id
  final String appId;

  /// qq app key
  final String appKey;

  QQAuthEntry({required this.appId, required this.appKey});

  Map<String, dynamic> toMap() {
    return {"appId": appId, "appKey": appKey};
  }
}
