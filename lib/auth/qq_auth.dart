import 'package:eyflutter_social/auth/auth_provider.dart';
import 'package:eyflutter_social/beans/qq_auth_entry.dart';
import 'package:eyflutter_social/enums/auth_type.dart';

class QQAuth extends AuthProvider {
  void authorize({required QQAuthEntry authEntry, required AuthorizeCall authorizeCall}) {
    var arguments = authEntry.toMap();
    arguments["authType"] = AuthType.qq.name;
    super.auth(arguments: arguments, authorizeCall: authorizeCall);
  }
}
