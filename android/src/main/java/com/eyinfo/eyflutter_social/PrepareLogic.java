package com.eyinfo.eyflutter_social;

import android.text.TextUtils;

import com.cloud.eyutils.utils.ObjectJudge;
import com.eyinfo.eyflutter_social.beans.ShareInfo;
import com.eyinfo.eyflutter_social.enums.SharePlatform;
import com.eyinfo.eyflutter_social.enums.ShareType;
import com.eyinfo.eyflutter_social.enums.SocialCallType;
import com.eyinfo.eyflutter_social.enums.SocialType;
import com.eyinfo.eyflutter_social.events.SocialAuthShareCall;
import com.eyinfo.eyflutter_social.utils.DetectionUtils;

import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.tencent.qzone.QZone;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;
import io.flutter.plugin.common.MethodChannel;

public class PrepareLogic {
    public static boolean checkPlatformInstall(MethodChannel.Result result, String platform, SocialAuthShareCall call, SocialType socialType) {
        if (TextUtils.equals(platform, SharePlatform.weixin.name()) ||
                TextUtils.equals(platform, SharePlatform.moments.name())) {
            //未安装微信应用
            if (!DetectionUtils.hasWechat()) {
                call.onError(SocialCallType.noInstall, platform, socialType, "微信未安装");
                HashMap<String, Object> callMap = new HashMap<>();
                callMap.put("callType", SocialCallType.noInstall.name());
                callMap.put("message", "微信未安装");
                result.success(callMap);
                return false;
            }
        } else if (TextUtils.equals(platform, SharePlatform.qq.name()) ||
                TextUtils.equals(platform, SharePlatform.qzone.name())) {
            //未安装QQ应用
            if (!DetectionUtils.hasQQ()) {
                call.onError(SocialCallType.noInstall, platform, socialType, "QQ未安装");
                HashMap<String, Object> callMap = new HashMap<>();
                callMap.put("callType", SocialCallType.noInstall.name());
                callMap.put("message", "QQ未安装");
                result.success(callMap);
                return false;
            }
        } else if (TextUtils.equals(platform, SharePlatform.weibo.name())) {
            //未安装微博应用
            if (!DetectionUtils.hasSina()) {
                call.onError(SocialCallType.noInstall, platform, socialType, "微博未安装");
                HashMap<String, Object> callMap = new HashMap<>();
                callMap.put("callType", SocialCallType.noInstall.name());
                callMap.put("message", "微博未安装");
                result.success(callMap);
                return false;
            }
        }
        return true;
    }

    private static Platform.ShareParams getPlatformParams(String platformName) {
        Platform.ShareParams shareParams;
        if (TextUtils.equals(platformName, SharePlatform.weixin.name())) {
            shareParams = new Wechat.ShareParams();
        } else if (TextUtils.equals(platformName, SharePlatform.moments.name())) {
            shareParams = new WechatMoments.ShareParams();
        } else if (TextUtils.equals(platformName, SharePlatform.weibo.name())) {
            shareParams = new SinaWeibo.ShareParams();
        } else if (TextUtils.equals(platformName, SharePlatform.qq.name())) {
            shareParams = new QQ.ShareParams();
        } else if (TextUtils.equals(platformName, SharePlatform.qzone.name())) {
            shareParams = new QZone.ShareParams();
        } else {
            shareParams = new Platform.ShareParams();
        }
        return shareParams;
    }

    public static Platform.ShareParams prepareShareInfo(ShareInfo shareInfo) {
        Platform.ShareParams shareParams = getPlatformParams(shareInfo.getPlatform());
        if (TextUtils.equals(shareInfo.getPlatform(), SharePlatform.qq.name()) ||
                TextUtils.equals(shareInfo.getPlatform(), SharePlatform.qzone.name())) {
            if (TextUtils.equals(shareInfo.getShareType(), ShareType.image.name())) {
                //QQ图片分享
                shareParams.setImageUrl(shareInfo.getImageUrl());
            } else {
                shareParams.setTitle(shareInfo.getTitle());
                shareParams.setTitleUrl(shareInfo.getUrl());
                shareParams.setText(shareInfo.getDescribe());
                //分享图片如果内容有图则取内容第一张图片,反之取logo
                String imageUrl = shareInfo.getImageUrl();
                if (!ObjectJudge.isEmptyString(imageUrl)) {
                    shareParams.setImageUrl(imageUrl);
                }
            }
        } else {
            if (TextUtils.equals(shareInfo.getShareType(), ShareType.text.name())) {
                //文本分享
                shareParams.setShareType(Platform.SHARE_TEXT);
                shareParams.setText(shareInfo.getDescribe());
            } else if (TextUtils.equals(shareInfo.getShareType(), ShareType.image.name())) {
                //图片分享
                shareParams.setTitle(shareInfo.getTitle());
                shareParams.setText(shareInfo.getDescribe());
                shareParams.setImageUrl(shareInfo.getImageUrl());
                shareParams.setShareType(Platform.SHARE_IMAGE);
            } else {
                shareParams.setTitle(shareInfo.getTitle());
                shareParams.setText(shareInfo.getDescribe());
                //分享图片如果内容有图则取内容第一张图片,反之取logo
                String imageUrl = shareInfo.getImageUrl();
                if (!ObjectJudge.isEmptyString(imageUrl)) {
                    shareParams.setImageUrl(imageUrl);
                }
                shareParams.setUrl(shareInfo.getUrl());
                shareParams.setShareType(Platform.SHARE_WEBPAGE);
            }
        }
        return shareParams;
    }
}
