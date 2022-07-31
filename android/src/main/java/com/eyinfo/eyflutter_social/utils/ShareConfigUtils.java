package com.eyinfo.eyflutter_social.utils;

import android.text.TextUtils;

import com.eyinfo.eyflutter_social.beans.SocialConfigInfo;
import com.eyinfo.eyflutter_social.enums.SharePlatform;

import java.util.HashMap;

import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.tencent.qzone.QZone;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

public class ShareConfigUtils {

    public static String getSdkPlatform(String platform) {
        if (TextUtils.equals(platform, SharePlatform.weibo.name())) {
            return SinaWeibo.NAME;
        } else if (TextUtils.equals(platform, SharePlatform.qzone.name())) {
            return QZone.NAME;
        } else if (TextUtils.equals(platform, SharePlatform.weixin.name())) {
            return Wechat.NAME;
        } else if (TextUtils.equals(platform, SharePlatform.moments.name())) {
            return WechatMoments.NAME;
        } else if (TextUtils.equals(platform, SharePlatform.qq.name())) {
            return QQ.NAME;
        }
        return "";
    }

    public static void setting(String platform, SocialConfigInfo configInfo) {
        if (TextUtils.equals(platform, SharePlatform.weibo.name())) {
            //sinaweibo
            HashMap<String, Object> sinaMap = new HashMap<String, Object>();
            sinaMap.put("Id", "1");
            sinaMap.put("SortId", "1");
            sinaMap.put("AppKey", configInfo.getSinaAppKey());
            sinaMap.put("AppSecret", configInfo.getSinaAppSecret());
            sinaMap.put("RedirectUrl", configInfo.getSinaRedirectUrl());
            sinaMap.put("ShareByAppClient", "true");
            sinaMap.put("Enable", "true");
            ShareSDK.setPlatformDevInfo(SinaWeibo.NAME, sinaMap);
        } else if (TextUtils.equals(platform, SharePlatform.qzone.name())) {
            //qzone
            HashMap<String, Object> qzoneMap = new HashMap<String, Object>();
            qzoneMap.put("Id", "3");
            qzoneMap.put("SortId", "3");
            qzoneMap.put("AppId", configInfo.getQqAppId());
            qzoneMap.put("AppKey", configInfo.getQqAppKey());
            qzoneMap.put("ShareByAppClient", "true");
            qzoneMap.put("BypassApproval", "false");
            qzoneMap.put("Enable", "true");
            ShareSDK.setPlatformDevInfo(QZone.NAME, qzoneMap);
        } else if (TextUtils.equals(platform, SharePlatform.weixin.name())) {
            //微信
            HashMap<String, Object> wechatMap = new HashMap<String, Object>();
            wechatMap.put("Id", "4");
            wechatMap.put("SortId", "4");
            wechatMap.put("AppId", configInfo.getWechatAppId());
            wechatMap.put("AppSecret", configInfo.getWechatAppSecret());
            wechatMap.put("BypassApproval", "false");
            wechatMap.put("Enable", "true");
            ShareSDK.setPlatformDevInfo(Wechat.NAME, wechatMap);
        } else if (TextUtils.equals(platform, SharePlatform.moments.name())) {
            //朋友圈
            HashMap<String, Object> wechatMomentMap = new HashMap<String, Object>();
            wechatMomentMap.put("Id", "5");
            wechatMomentMap.put("SortId", "5");
            wechatMomentMap.put("AppId", configInfo.getWechatAppId());
            wechatMomentMap.put("AppSecret", configInfo.getWechatAppSecret());
            wechatMomentMap.put("BypassApproval", "false");
            wechatMomentMap.put("Enable", "true");
            ShareSDK.setPlatformDevInfo(WechatMoments.NAME, wechatMomentMap);
        } else if (TextUtils.equals(platform, SharePlatform.qq.name())) {
            //qq
            HashMap<String, Object> qqMap = new HashMap<String, Object>();
            qqMap.put("Id", "7");
            qqMap.put("SortId", "7");
            qqMap.put("AppId", configInfo.getQqAppId());
            qqMap.put("AppKey", configInfo.getQqAppKey());
            qqMap.put("ShareByAppClient", "true");
            qqMap.put("BypassApproval", "false");
            qqMap.put("Enable", "true");
            ShareSDK.setPlatformDevInfo(QQ.NAME, qqMap);
        }
    }
}
