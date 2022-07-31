#import "EyflutterSocialPlugin.h"
#if __has_include(<eyflutter_social/eyflutter_social-Swift.h>)
#import <eyflutter_social/eyflutter_social-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "eyflutter_social-Swift.h"
#endif

#import <ShareSDK/ShareSDK.h>
#import <MOBFoundation/MobSDK+Privacy.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <AlipaySDK/AlipaySDK.h>

@interface WxRespDelegate : NSObject <WXApiDelegate>

@end

@implementation EyflutterSocialPlugin

static AliPayCall aliPayCall;
static WeChatReqCall weChatReqCall;
static WeChatPayCall weChatPayCall;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEyflutterSocialPlugin registerWithRegistrar:registrar];
}

+ (void)initShareSdkKeys:(NSDictionary*) params {
    if (params != NULL && [params count] > 0) {
        //隐私协议
        [MobSDK uploadPrivacyPermissionStatus:true onResult:^(BOOL success) {
            //隐私协议回调
        }];
        [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
            //微信
            NSString* wechatAppId = [params valueForKey:@"wechatAppId"];
            NSString* wechatAppSecret = [params valueForKey:@"wechatAppSecret"];
            NSString* wechatUniversalLink = [params valueForKey:@"wechatUniversalLink"];
            [platformsRegister setupWeChatWithAppId:wechatAppId appSecret:wechatAppSecret universalLink:wechatUniversalLink];
            //qq
            NSString* qqAppId = [params valueForKey:@"qqAppId"];
            NSString* qqAppKey = [params valueForKey:@"qqAppKey"];
            [platformsRegister setupQQWithAppId:qqAppId appkey:qqAppKey enableUniversalLink:false universalLink:@""];
            //新浪微博
            NSString* sinaAppKey = [params valueForKey:@"sinaAppKey"];
            NSString* sinaAppSecret = [params valueForKey:@"sinaAppSecret"];
            NSString* sinaRedirectUrl = [params valueForKey:@"sinaRedirectUrl"];
            [platformsRegister setupSinaWeiboWithAppkey:sinaAppKey appSecret:sinaAppSecret redirectUrl:sinaRedirectUrl universalLink:@""];
        }];
    }
}

+ (void) share:(NSDictionary *)params onShareCall:(ShareStatusCall) statusCall {
    NSString* callKey = [params valueForKey:@"flutter_result_call_key"];
    NSString* platform = [params valueForKey:@"platform"];
    // 获取分享平台
    SSDKPlatformType platformType = [self getSdkPlatform:platform];
    if (platformType == SSDKPlatformTypeUnknown) {
        statusCall(@"platformEmpty",callKey,@"未获取到分享平台");
        return;
    }
    if ([platform isEqual:@"weixin"] || [platform isEqual:@"moments"]) {
        if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat] == NO) {
            statusCall(@"noInstall",callKey,@"微信客户端未安装");
            return;
        }
    } else if ([platform isEqual:@"qq"]) {
        if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ] == NO) {
            statusCall(@"noInstall",callKey,@"QQ客户端未安装");
            return;
        }
    } else if ([platform isEqual:@"weibo"]) {
        if ([ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo] == NO) {
            statusCall(@"noInstall",callKey,@"微博客户端未安装");
            return;
        }
    }
    NSMutableDictionary* shareParams = [self prepareShareParams:params];
    [ShareSDK share:platformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        if (state == SSDKResponseStateBegin) {
            // 开始启动第三方客户端,当前loading结束
            statusCall(@"start",callKey,@"");
        } else if (state == SSDKResponseStateSuccess) {
            // 分享成功
            statusCall(@"success",callKey,@"");
        } else if (state == SSDKResponseStateFail) {
            // 分享失败
            statusCall(@"fail",callKey,@"");
        } else if (state == SSDKResponseStateCancel || state == SSDKResponseStatePlatformCancel){
            // sdk或平台取消
            statusCall(@"cancel",callKey,@"");
        }
    }];
}

+ (SSDKContentType) getShareContentType:(NSString*) shareType {
    if ([shareType isEqual:@"text"]) {
        return SSDKContentTypeText;
    } else if ([shareType isEqual:@"image"]) {
        return SSDKContentTypeImage;
    } else {
        return SSDKContentTypeWebPage;
    }
}

+ (NSMutableDictionary*) prepareShareParams:(NSDictionary*) params {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString* platform = [params valueForKey:@"platform"];
    NSString* title = [params valueForKey:@"title"];
    NSString* describe = [params valueForKey:@"describe"];
    NSString* shareType = [params valueForKey:@"shareType"];
    NSString* url = [params valueForKey:@"url"];
    NSString* imageUrl = [params valueForKey:@"imageUrl"];
    if ([platform isEqual:@"qq"]) {
        //QQ好友
        [shareParams SSDKSetupQQParamsByText:describe title:title url:[NSURL URLWithString:url] audioFlashURL:nil videoFlashURL:nil thumbImage:nil images:@[imageUrl] type:[self getShareContentType:shareType] forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    } else if ([platform isEqual:@"qzone"]) {
        //QQ空间
        [shareParams SSDKSetupQQParamsByText:describe title:title url:[NSURL URLWithString:url] audioFlashURL:nil videoFlashURL:nil thumbImage:nil images:@[imageUrl] type:[self getShareContentType:shareType] forPlatformSubType:SSDKPlatformSubTypeQZone];
    } else if ([platform isEqual:@"weixin"]) {
        //微信好友
        [shareParams SSDKSetupWeChatParamsByText:describe title:title url:[NSURL URLWithString:url] thumbImage:nil image:imageUrl musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:[self getShareContentType:shareType] forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    } else if ([platform isEqual:@"moments"]) {
        //微信朋友圈
        [shareParams SSDKSetupWeChatParamsByText:describe title:title url:[NSURL URLWithString:url] thumbImage:nil image:imageUrl musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:[self getShareContentType:shareType] forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    } else if ([platform isEqual:@"weibo"]) {
        //微博
        [shareParams SSDKSetupSinaWeiboShareParamsByText:describe title:title images:@[imageUrl] video:nil url:[NSURL URLWithString:url] latitude:0 longitude:0 objectID:nil isShareToStory:false type:[self getShareContentType:shareType]];
    }
    return shareParams;
}

+ (SSDKPlatformType)getSdkPlatform:(NSString *)platform {
    if ([platform  isEqual: @"weibo"]) {
        return SSDKPlatformTypeSinaWeibo;
    } else if ([platform isEqual:@"qzone"]) {
        return SSDKPlatformSubTypeQZone;
    } else if ([platform isEqual:@"weixin"]) {
        return SSDKPlatformTypeWechat;
    } else if ([platform isEqual:@"moments"]) {
        return SSDKPlatformSubTypeWechatTimeline;
    } else if ([platform isEqual:@"qq"]) {
        return SSDKPlatformTypeQQ;
    }
    return SSDKPlatformTypeUnknown;
}

+ (void)doPay:(NSString *)orderString appScheme:(NSString *)scheme payCall:(AliPayCall)call {
    aliPayCall = call;
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:scheme callback:^(NSDictionary *resultDic) {
        aliPayCall = nil;
        if (call != nil) {
            call(resultDic);
        }
    }];
}

+ (void)doPayCall:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if (aliPayCall != nil) {
                aliPayCall(resultDic);
            }
        }];
        
        // 授权跳转支付宝钱包进行授权，处理授权结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
        }];
    }
}

+(void)initializeWeChatPay:(NSString *)weChatAppId universalLink:(NSString *)universalLink {
    //注册微信
    [WXApi registerApp:weChatAppId universalLink:universalLink];
}

+ (void)doWeChatPay:(NSDictionary *)params reqCall:(WeChatReqCall)weChatReqCall payCall:(WeChatPayCall)weChatPayCall {
    PayReq *req = [[PayReq alloc] init];
    req.openID = [params valueForKey:@"appId"]; //APPID
    req.partnerId = [params valueForKey:@"partnerId"];//商户号
    req.prepayId = [params valueForKey:@"prepayId"];//预支付交易会话ID
    req.nonceStr = [params valueForKey:@"nonceStr"];//随机字符串
    req.package = @"Sign=WXPay";//扩展字段
    req.timeStamp = [[params valueForKey:@"timestamp"] intValue];//时间戳
    req.sign = [params valueForKey:@"sign"];//签名
    [WXApi sendReq:req completion:^(BOOL success) {
        if (weChatReqCall == nil) {
            return;
        }
        if (!success) {
            weChatReqCall(@"wx_pay_fail", @"微信未安装或版本过低");
        }
    }];
}

+ (void)doWeChatPayCall:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        return;
    }
    [WXApi handleOpenURL:url delegate:[WxRespDelegate self]];
}

+ (void)doWeChatAuth:(NSDictionary *)params authCall:(AuthorizeCall) authorizeCall{
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        if (state == SSDKResponseStateBegin || state == SSDKUploadStateUploading) {
            return;
        }
        [resultDic setValue:@"weChat" forKey:@"authType"];
        if (state == SSDKResponseStateSuccess) {
            [resultDic setValue:@"success" forKey:@"authStatus"];
            [resultDic setValue:user.uid forKey:@"unionId"];
            [resultDic setValue:user.nickname forKey:@"nickName"];
            //性别 男-0 女-1 未知-2
            [resultDic setValue:[NSString stringWithFormat:@"%ld", (long)user.gender] forKey:@"gender"];
            [resultDic setValue:user.icon forKey:@"portrait"];
            authorizeCall(resultDic);
        } else if(state == SSDKResponseStateCancel || state == SSDKResponseStatePlatformCancel) {
            [resultDic setValue:@"cancel" forKey:@"authStatus"];
            authorizeCall(resultDic);
        } else if(state == SSDKResponseStateFail) {
            [resultDic setValue:@"fail" forKey:@"authStatus"];
            authorizeCall(resultDic);
        }
    }];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat result:^(NSError *error) {
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        [resultDic setValue:@"weChat" forKey:@"authType"];
        [resultDic setValue:@"cancel" forKey:@"authStatus"];
        authorizeCall(resultDic);
    }];
}

+ (void)doQQAuth:(NSDictionary *)params authCall:(AuthorizeCall)authorizeCall {
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        if (state == SSDKResponseStateBegin || state == SSDKUploadStateUploading) {
            return;
        }
        [resultDic setValue:@"qq" forKey:@"authType"];
        if (state == SSDKResponseStateSuccess) {
            [resultDic setValue:@"success" forKey:@"authStatus"];
            [resultDic setValue:user.uid forKey:@"unionId"];
            [resultDic setValue:user.nickname forKey:@"nickName"];
            //性别 男-0 女-1 未知-2
            [resultDic setValue:[NSString stringWithFormat:@"%ld", (long)user.gender] forKey:@"gender"];
            [resultDic setValue:user.icon forKey:@"portrait"];
            authorizeCall(resultDic);
        } else if(state == SSDKResponseStateCancel || state == SSDKResponseStatePlatformCancel) {
            [resultDic setValue:@"cancel" forKey:@"authStatus"];
            authorizeCall(resultDic);
        } else if(state == SSDKResponseStateFail) {
            [resultDic setValue:@"fail" forKey:@"authStatus"];
            authorizeCall(resultDic);
        }
    }];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ result:^(NSError *error) {
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        [resultDic setValue:@"qq" forKey:@"authType"];
        [resultDic setValue:@"cancel" forKey:@"authStatus"];
        authorizeCall(resultDic);
    }];
}

+ (void)doWeiBoAuth:(NSDictionary *)params authCall:(AuthorizeCall)authorizeCall {
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        if (state == SSDKResponseStateBegin || state == SSDKUploadStateUploading) {
            return;
        }
        [resultDic setValue:@"weiBo" forKey:@"authType"];
        if (state == SSDKResponseStateSuccess) {
            [resultDic setValue:@"success" forKey:@"authStatus"];
            [resultDic setValue:user.uid forKey:@"unionId"];
            [resultDic setValue:user.nickname forKey:@"nickName"];
            //性别 男-0 女-1 未知-2
            [resultDic setValue:[NSString stringWithFormat:@"%ld", (long)user.gender] forKey:@"gender"];
            [resultDic setValue:user.icon forKey:@"portrait"];
            authorizeCall(resultDic);
        } else if(state == SSDKResponseStateCancel || state == SSDKResponseStatePlatformCancel) {
            [resultDic setValue:@"cancel" forKey:@"authStatus"];
            authorizeCall(resultDic);
        } else if(state == SSDKResponseStateFail) {
            [resultDic setValue:@"fail" forKey:@"authStatus"];
            authorizeCall(resultDic);
        }
    }];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo result:^(NSError *error) {
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        [resultDic setValue:@"weiBo" forKey:@"authType"];
        [resultDic setValue:@"cancel" forKey:@"authStatus"];
        authorizeCall(resultDic);
    }];
}

@end

@implementation WxRespDelegate

-(void) onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp*)resp;
        switch (response.errCode) {
            case WXSuccess: {
                if (weChatPayCall != nil) {
                    weChatPayCall(@"wx_pay_success", @"支付成功");
                }
                break;
            }
            case WXErrCodeSentFail: {
                if (weChatPayCall != nil) {
                    weChatPayCall(@"wx_pay_fail", @"支付请求发送失败请重试");
                }
                break;
            }
            case WXErrCodeAuthDeny: {
                if (weChatPayCall != nil) {
                    weChatPayCall(@"wx_pay_fail", @"微信授权失败");
                }
                break;
            }
            case WXErrCodeUnsupport: {
                if (weChatPayCall != nil) {
                    weChatPayCall(@"wx_pay_fail", @"微信不支持或版本太低");
                }
                break;
            }
            case WXErrCodeCommon: {
                if (weChatPayCall != nil) {
                    weChatPayCall(@"wx_pay_fail", @"支付异常请重试");
                }
                break;
            }
            case WXErrCodeUserCancel: {
                if (weChatPayCall != nil) {
                    weChatPayCall(@"wx_pay_cancel", @"支付已取消");
                }
                break;
            }
            default:
                break;
        }
    }
}

@end
