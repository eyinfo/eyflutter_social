import Flutter
import UIKit
import eyflutter_core
import eyflutter_uikit

//支付接入流程：https://opendocs.alipay.com/open/204/105295/
public class SwiftEyflutterSocialPlugin: NSObject, FlutterPlugin {
    
    static var isInitializedMob:Bool = false;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        isInitializedMob = false;
        FNUrlRoute.register(key: "1f4482ba6ba89bbe", module:MobInitConfigReceive.self);
        FNUrlRoute.register(key: "1964acb974df863f", module:ShareReceive.self);
        FNUrlRoute.register(key: "d9d49a7a501d9436", module: AliPayReceive.self)
        FNUrlRoute.register(key: "62d478aa6f121ac2", module: WeChatPayConfigReceive.self)
        FNUrlRoute.register(key: "7144a3ab855396d9", module: WeChatPayReceive.self)
        FNUrlRoute.register(key: "645462eb0d811360", module: AuthReceive.self)
    }
    
    public class MobInitConfigReceive: FNUrlRouteDelegate {
            public required init(params: Dictionary<String, AnyObject>?) {
                if !SwiftEyflutterSocialPlugin.isInitializedMob {
                    SwiftEyflutterSocialPlugin.isInitializedMob = true;
                    EyflutterSocialPlugin.initShareSdkKeys(params);
                }
                let callKey = params!["flutter_result_call_key"] as! String;
                ChannelPlugin.resultCall(resultKey: callKey, callbackData: "success");
            }
        }
        
        public class ShareReceive: FNUrlRouteDelegate {
            public required init(params: Dictionary<String, AnyObject>?) {
                EyflutterSocialPlugin.share(params) { (callType: String?, callKey: String?, message: String?) in
                    let result = ["callType":callType,"message":message]
                    ChannelPlugin.resultCall(resultKey: callKey!, callbackData: result);
                }
            }
        }
        
        //9000 订单支付成功
        //8000 正在处理中
        //4000 订单支付失败
        //6001 用户中途取消
        //6002 网络连接出错
        public class AliPayReceive: FNUrlRouteDelegate {
            public required init(params: Dictionary<String, AnyObject>?) {
                let entry = getPayEntry(params: params)
                EyflutterSocialPlugin.doPay(entry.sign, appScheme: entry.appScheme) { (resultDic:Dictionary?) in
                    let resultStatus = ConvertUtils.toString(value: resultDic!["resultStatus"] as AnyObject)
                    let response = resultDic!["memo"]
                    var channelParams : Dictionary<String, AnyObject> = [:]
                    if resultStatus == "9000" {
                        channelParams["status"] = "success" as AnyObject
                        channelParams["response"] = response as AnyObject?
                    } else if resultStatus == "8000" {
                        channelParams["status"] = "processing" as AnyObject
                        channelParams["response"] = response as AnyObject?
                    } else if resultStatus == "6001" {
                        channelParams["status"] = "cancel" as AnyObject
                        channelParams["response"] = response as AnyObject?
                    } else if resultStatus == "6002" {
                        channelParams["status"] = "disconnected" as AnyObject
                        channelParams["response"] = response as AnyObject?
                    } else {
                        channelParams["status"] = "fail" as AnyObject
                        channelParams["response"] = response as AnyObject?
                    }
                    ChannelPlugin.invokeMethod(action: "0904c07a0b33d339", params: channelParams)
                }
                ChannelPlugin.remove(params: params!)
            }
            
            func getPayEntry(params: Dictionary<String, AnyObject>?) -> AliPayEntry {
                var entry = AliPayEntry()
                entry.sign = ConvertUtils.toString(value: params!["sign"])
                entry.appScheme = ConvertUtils.toString(value: params!["appScheme"])
                return entry
            }
        }

        public class WeChatPayConfigReceive: FNUrlRouteDelegate {
            public required init(params: Dictionary<String, AnyObject>?) {
                let appId = ConvertUtils.toString(value: params!["appId"])
                let universalLink = ConvertUtils.toString(value: params!["universalLink"])
                //微信初始化
                EyflutterSocialPlugin.initializeWeChatPay(appId, universalLink: universalLink)
                //通知flutter触发微信支付
                let callKey = params!["flutter_result_call_key"] as! String;
                ChannelPlugin.resultCall(resultKey: callKey, callbackData: "success");
            }
        }
        
        public class WeChatPayReceive: FNUrlRouteDelegate {
            public required init(params: Dictionary<String, AnyObject>?) {
                let wechatPayResponseChannelName = "a48409d9f8520605"
                var resultParams : Dictionary<String, AnyObject> = [:]
                EyflutterSocialPlugin.doWeChatPay(params!, reqCall: {(callKey : String?, message : String?) in
                    resultParams["status"] = callKey as AnyObject?
                    resultParams["response"] = message as AnyObject?
                    ChannelPlugin.invokeMethod(action: wechatPayResponseChannelName, params: resultParams)
                }, payCall: {(callKey : String?, message : String?) in
                    resultParams["status"] = callKey as AnyObject?
                    resultParams["response"] = message as AnyObject?
                    ChannelPlugin.invokeMethod(action: wechatPayResponseChannelName, params: resultParams)
                })
                //移除当前key避免内存泄漏
                ChannelPlugin.remove(params: params!)
            }
        }
        
        public class AuthReceive: FNUrlRouteDelegate {
            public required init(params: Dictionary<String, AnyObject>?) {
                let authStatusChannelName = "24d497f8077bc334"
                let authType = ConvertUtils.toString(value: params!["authType"])
                if authType == "weChat" {
                    EyflutterSocialPlugin.doWeChatAuth(params!) { (resultDic : Dictionary?) in
                        ChannelPlugin.invokeMethod(action: authStatusChannelName, params: resultDic)
                    }
                } else if authType == "qq" {
                    EyflutterSocialPlugin.doQQAuth(params!) { (resultDic : Dictionary?) in
                        ChannelPlugin.invokeMethod(action: authStatusChannelName, params: resultDic)
                    }
                } else if authType == "weiBo" {
                    EyflutterSocialPlugin.doWeiBoAuth(params!) { (resultDic : Dictionary?) in
                        ChannelPlugin.invokeMethod(action: authStatusChannelName, params: resultDic)
                    }
                }
                //移除当前key避免内存泄漏
                ChannelPlugin.remove(params: params!)
            }
        }
}
