import 'package:eyflutter_social/auth/auth_provider.dart';
import 'package:eyflutter_social/beans/weibo_auth_entry.dart';
import 'package:eyflutter_social/enums/auth_type.dart';

class WeiBoAuth extends AuthProvider {
  void authorize({required WeiBoAuthEntry authEntry, required AuthorizeCall authorizeCall}) {
    var arguments = authEntry.toMap();
    arguments["authType"] = AuthType.weiBo.name;
    super.auth(arguments: arguments, authorizeCall: authorizeCall);
  }
}
