package com.eyinfo.eyflutter_social;

import android.app.Activity;
import android.text.TextUtils;

import com.cloud.eyutils.HandlerManager;
import com.cloud.eyutils.events.RunnableParamsN;
import com.cloud.eyutils.launchs.LauncherState;
import com.cloud.eyutils.utils.ConvertUtils;
import com.cloud.eyutils.utils.JsonUtils;
import com.cloud.eyutils.utils.ObjectJudge;

import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.PlatformDb;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.wechat.friends.Wechat;
import io.flutter.plugin.common.MethodChannel;

import com.basic.eyflutter_core.channel.ChannelPlugin;

public class AuthController {

    public void authorize(MethodChannel.Result result, HashMap<String, Object> arguments) {
        if (ObjectJudge.isNullOrEmpty(arguments)) {
            return;
        }
        checkAuthConfig(arguments);
        String platformName = getPlatformName(arguments);
        if (TextUtils.isEmpty(platformName)) {
            return;
        }
        Platform platform = ShareSDK.getPlatform(platformName);
        if (platform == null) {
            return;
        }
        Activity currActivity = LauncherState.getInstance().getRecentlyCreateActivity();
        if (currActivity != null) {
            ShareSDK.setActivity(currActivity);
        }
        platform.setPlatformActionListener(new AuthActionCall());
        platform.showUser(null);
    }

    private class AuthActionCall implements PlatformActionListener {

        @Override
        public void onComplete(Platform platform, int i, HashMap<String, Object> hashMap) {
            HashMap<String, Object> resultMap = new HashMap<>();
            String platformName = platform.getName();
            String authType = getAuthType(platformName);
            resultMap.put("authType", authType);
            if (TextUtils.equals(platformName, Wechat.NAME)) {
                resultMap.put("authStatus", "success");
                resultMap.put("openId", hashMap.get("openid"));
                resultMap.put("unionId", hashMap.get("unionid"));
                resultMap.put("nickName", hashMap.get("nickname"));
                resultMap.put("gender", hashMap.get("sex"));
                resultMap.put("portrait", hashMap.get("headimgurl"));
                resultMap.put("country", hashMap.get("country"));
                resultMap.put("province", hashMap.get("province"));
                resultMap.put("city", hashMap.get("city"));
            } else if (TextUtils.equals(platformName, QQ.NAME)) {
                resultMap.put("authStatus", "success");
                PlatformDb db = platform.getDb();
                if (db == null) {
                    resultMap.put("openId", "");
                } else {
                    String data = db.exportData();
                    String userId = db.getUserId();
                    if (TextUtils.isEmpty(data)) {
                        resultMap.put("openId", userId);
                    } else {
                        if (TextUtils.isEmpty(userId)) {
                            resultMap.put("openId", data);
                        } else {
                            resultMap.put("openId", userId);
                        }
                    }
                    resultMap.put("unionId", JsonUtils.getValue("unionid", data));
                }
                resultMap.put("nickName", hashMap.get("nickname"));
                resultMap.put("gender", hashMap.get("gender"));
                resultMap.put("portrait", hashMap.get("figureurl_qq"));
                resultMap.put("province", hashMap.get("province"));
                resultMap.put("city", hashMap.get("city"));

            } else if (TextUtils.equals(platformName, SinaWeibo.NAME)) {
                resultMap.put("authStatus", "success");
                // TODO: 2020/12/9
            }
            notifyDart(resultMap);
        }

        @Override
        public void onError(Platform platform, int i, Throwable throwable) {
            HashMap<String, Object> resultMap = new HashMap<>();
            String platformName = platform.getName();
            String authType = getAuthType(platformName);
            resultMap.put("authType", authType);
            resultMap.put("authStatus", "fail");
            notifyDart(resultMap);
        }

        @Override
        public void onCancel(Platform platform, int i) {
            HashMap<String, Object> resultMap = new HashMap<>();
            String platformName = platform.getName();
            String authType = getAuthType(platformName);
            resultMap.put("authType", authType);
            resultMap.put("authStatus", "cancel");
            notifyDart(resultMap);
        }
    }

    private void notifyDart(HashMap<String, Object> resultMap) {
        HandlerManager.getInstance().post(new RunnableParamsN<HashMap<String, Object>>() {
            @Override
            public void run(HashMap<String, Object>... params) {
                HashMap<String, Object> map = params[0];
                ChannelPlugin.getInstance().invokeMethod(SocialChannelKeys.authStatusChannelName, map, null);
            }
        }, resultMap);
    }

    private String getAuthType(String platformName) {
        if (TextUtils.equals(platformName, Wechat.NAME)) {
            return "weChat";
        } else if (TextUtils.equals(platformName, QQ.NAME)) {
            return "qq";
        } else if (TextUtils.equals(platformName, SinaWeibo.NAME)) {
            return "weiBo";
        }
        return "";
    }

    private String getPlatformName(HashMap<String, Object> arguments) {
        String authType = ConvertUtils.toString(arguments.get("authType"));
        if (TextUtils.equals(authType, "weChat")) {
            return Wechat.NAME;
        } else if (TextUtils.equals(authType, "qq")) {
            return QQ.NAME;
        } else if (TextUtils.equals(authType, "weiBo")) {
            return SinaWeibo.NAME;
        }
        return "";
    }

    private void checkAuthConfig(HashMap<String, Object> arguments) {
        String authType = ConvertUtils.toString(arguments.get("authType"));
        if (TextUtils.equals(authType, "weChat")) {
            HashMap<String, Object> wechatMap = new HashMap<String, Object>();
            wechatMap.put("Id", "4");
            wechatMap.put("SortId", "4");
            wechatMap.put("AppId", arguments.get("appId"));
            wechatMap.put("AppSecret", arguments.get("appSecret"));
            wechatMap.put("BypassApproval", "false");
            wechatMap.put("Enable", "true");
            ShareSDK.setPlatformDevInfo(Wechat.NAME, wechatMap);
        } else if (TextUtils.equals(authType, "qq")) {
            HashMap<String, Object> qqMap = new HashMap<String, Object>();
            qqMap.put("Id", "7");
            qqMap.put("SortId", "7");
            qqMap.put("AppId", arguments.get("appId"));
            qqMap.put("AppKey", arguments.get("appKey"));
            qqMap.put("ShareByAppClient", "true");
            qqMap.put("BypassApproval", "false");
            qqMap.put("Enable", "true");
            ShareSDK.setPlatformDevInfo(QQ.NAME, qqMap);
        } else if (TextUtils.equals(authType, "weiBo")) {
            HashMap<String, Object> sinaMap = new HashMap<String, Object>();
            sinaMap.put("Id", "1");
            sinaMap.put("SortId", "1");
            sinaMap.put("AppKey", arguments.get("appKey"));
            sinaMap.put("AppSecret", arguments.get("appSecret"));
            sinaMap.put("RedirectUrl", arguments.get("redirectUrl"));
            sinaMap.put("ShareByAppClient", "true");
            sinaMap.put("Enable", "true");
            ShareSDK.setPlatformDevInfo(SinaWeibo.NAME, sinaMap);
        }
    }
}
