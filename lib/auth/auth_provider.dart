import 'package:eyflutter_core/eyflutter_core.dart';
import 'package:eyflutter_social/enums/auth_status.dart';
import 'package:eyflutter_social/enums/auth_type.dart';

typedef AuthorizeCall = void Function(AuthType authType, AuthStatus status, Map<String, dynamic> resultMap);

class AuthProvider {
  String authChannelName = "645462eb0d811360";
  String authStatusChannelName = "24d497f8077bc334";

  void auth({required Map<String, dynamic> arguments, required AuthorizeCall authorizeCall}) {
    CloudChannelManager.instance.channel?.setMethodCallHandler((call) {
      String method = call.method;
      var resultArguments = call.arguments;
      if (method == authStatusChannelName &&
          resultArguments is Map<String, dynamic> &&
          resultArguments.containsKey("authType")) {
        var authType = resultArguments.remove("authType");
        var status = resultArguments.remove("authStatus");
        if (authType == AuthType.weChat.name) {
          weChatAuthCall(status, authorizeCall, resultArguments);
        } else if (authType == AuthType.qq.name) {
          qqAuthCall(status, authorizeCall, resultArguments);
        } else if (authType == AuthType.weiBo.name) {
          weiBoAuthCall(status, authorizeCall, resultArguments);
        }
      }
      return Future.value(null);
    });
    CloudChannelManager.instance.send(authChannelName, arguments: arguments);
  }

  void weiBoAuthCall(AuthStatus status, AuthorizeCall authorizeCall, Map<String, dynamic> arguments) {
    if (status == AuthStatus.success) {
      authorizeCall(AuthType.weiBo, AuthStatus.success, arguments);
    } else if (status == AuthStatus.cancel) {
      authorizeCall(AuthType.weiBo, AuthStatus.cancel, arguments);
    } else {
      authorizeCall(AuthType.weiBo, AuthStatus.fail, arguments);
    }
  }

  void qqAuthCall(AuthStatus status, AuthorizeCall authorizeCall, Map<String, dynamic> arguments) {
    if (status == AuthStatus.success) {
      authorizeCall(AuthType.qq, AuthStatus.success, arguments);
    } else if (status == AuthStatus.cancel) {
      authorizeCall(AuthType.qq, AuthStatus.cancel, arguments);
    } else {
      authorizeCall(AuthType.qq, AuthStatus.fail, arguments);
    }
  }

  void weChatAuthCall(AuthStatus status, AuthorizeCall authorizeCall, Map<String, dynamic> arguments) {
    if (status == AuthStatus.success) {
      authorizeCall(AuthType.weChat, AuthStatus.success, arguments);
    } else if (status == AuthStatus.cancel) {
      authorizeCall(AuthType.weChat, AuthStatus.cancel, arguments);
    } else {
      authorizeCall(AuthType.weChat, AuthStatus.fail, arguments);
    }
  }
}
