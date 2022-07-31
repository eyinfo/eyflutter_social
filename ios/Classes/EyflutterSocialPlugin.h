#import <Flutter/Flutter.h>

/**
 分享回调
 @param callType 回调类型,platformEmpty noInstall 其中一个
 @param callKey 用于通知flutter键
 @param message 成功或错误消息
 */
typedef void(^ShareStatusCall) (NSString* callType, NSString* callKey, NSString* message);
typedef void(^AliPayCall) (NSDictionary* resultDic);
//微信请求时成功与失败回调
typedef void(^WeChatReqCall) (NSString* callKey, NSString* message);
//唤起微信后成功、失败、取消回调
typedef void(^WeChatPayCall) (NSString* callKey, NSString* message);
//授权回调
typedef void(^AuthorizeCall) (NSDictionary* resultDic);

@interface EyflutterSocialPlugin : NSObject<FlutterPlugin>

+(void)initShareSdkKeys:(NSDictionary*) params;

+(void)share:(NSDictionary*) params
 onShareCall:(ShareStatusCall) statusCall;

+(void)doPay:(NSString*) orderString
   appScheme:(NSString*) scheme
     payCall:(AliPayCall) call;

//支付回调在AppDelegate#application中调用
+(void)doPayCall:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options API_AVAILABLE(ios(9.0));

//初始化微信支付
//weChatAppId: 微信app id(在开放平台中获取)
+(void) initializeWeChatPay:(NSString*) weChatAppId
              universalLink:(NSString*) universalLink;

//微信支付
+(void)doWeChatPay:(NSDictionary*) params
           reqCall:(WeChatReqCall) weChatReqCall
           payCall:(WeChatPayCall) weChatPayCall;

//微信支付回调(需要在AppDelegate#appilcation中调用)
+(void)doWeChatPayCall:(NSURL*) url;

//微信授权
+(void)doWeChatAuth:(NSDictionary*) params authCall:(AuthorizeCall) authorizeCall;

//qq授权
+(void)doQQAuth:(NSDictionary*) params authCall:(AuthorizeCall) authorizeCall;

//新浪微博
+(void)doWeiBoAuth:(NSDictionary*) params authCall:(AuthorizeCall) authorizeCall;

@end
