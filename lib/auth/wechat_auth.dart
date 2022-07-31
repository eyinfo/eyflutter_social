import 'package:eyflutter_social/auth/auth_provider.dart';
import 'package:eyflutter_social/beans/wechat_auth_entry.dart';
import 'package:eyflutter_social/enums/auth_type.dart';

class WeChatAuth extends AuthProvider {
  void authorize({required WeChatAuthEntry authEntry, required AuthorizeCall authorizeCall}) {
    var arguments = authEntry.toMap();
    arguments["authType"] = AuthType.weChat.name;
    super.auth(arguments: arguments, authorizeCall: authorizeCall);
  }
}
