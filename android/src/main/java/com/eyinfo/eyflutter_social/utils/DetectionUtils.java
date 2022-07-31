package com.eyinfo.eyflutter_social.utils;

import android.content.Context;

import com.cloud.eyutils.launchs.LauncherState;

/**
 * Author lijinghuan
 * Email:ljh0576123@163.com
 * CreateTime:2020/7/23
 * Description:
 * Modifier:
 * ModifyContent:
 */
public class DetectionUtils {

    //是否安装微信
    public static boolean hasWechat() {
        Context applicationContext = LauncherState.getApplicationContext();
        return ApplicationUtils.checkApplicationInstalled(applicationContext, "weixin://");
    }

    //是否安装QQ
    public static boolean hasQQ() {
        Context applicationContext = LauncherState.getApplicationContext();
        return ApplicationUtils.checkApplicationInstalled(applicationContext, "mqq://");
    }

    //是否安装微博
    public static boolean hasSina() {
        Context applicationContext = LauncherState.getApplicationContext();
        return ApplicationUtils.checkApplicationInstalled(applicationContext, "sinaweibo://gotohome");
    }
}
