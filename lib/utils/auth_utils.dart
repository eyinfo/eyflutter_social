import 'package:eyflutter_social/auth/auth_provider.dart';
import 'package:eyflutter_social/auth/qq_auth.dart';
import 'package:eyflutter_social/auth/wechat_auth.dart';
import 'package:eyflutter_social/auth/weibo_auth.dart';
import 'package:eyflutter_social/enums/auth_type.dart';

class AuthUtils {
  AuthUtils._();

  /// 微信、qq、新浪微博授权
  /// [authType] 授权类型
  /// [authEntry] 授权数据：
  /// 当authType==AuthType.weChat时[WeChatAuthEntry]
  /// 当authType==AuthType.qq时[QQAuthEntry]
  /// 当authType==AuthType.weiBo时[WeiBoAuthEntry]
  /// [authorizeCall] 授权回调
  static void auth({required AuthType authType, dynamic authEntry, required AuthorizeCall authorizeCall}) {
    if (authType == AuthType.weChat) {
      var weChatAuth = WeChatAuth();
      weChatAuth.authorize(authEntry: authEntry, authorizeCall: authorizeCall);
    } else if (authType == AuthType.qq) {
      var qqAuth = QQAuth();
      qqAuth.authorize(authEntry: authEntry, authorizeCall: authorizeCall);
    } else if (authType == AuthType.weiBo) {
      var weiBoAuth = WeiBoAuth();
      weiBoAuth.authorize(authEntry: authEntry, authorizeCall: authorizeCall);
    }
  }
}
