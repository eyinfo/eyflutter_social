package com.eyinfo.eyflutter_social.utils;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;

import com.cloud.eyutils.utils.SharedPrefUtils;

/**
 * Author lijinghuan
 * Email:ljh0576123@163.com
 * CreateTime:2019/2/27
 * Description:应用程序工具类
 * Modifier:
 * ModifyContent:
 */
public class ApplicationUtils {

    /**
     * 检测应用是否已安装
     *
     * @param applicationContext 上下文(最好是Application上下文)
     * @param schemeUrl          第三方应用默认scheme url
     * @return
     */
    public static boolean checkApplicationInstalled(Context applicationContext, String schemeUrl) {
        if (applicationContext == null || TextUtils.isEmpty(schemeUrl)) {
            return false;
        }
        Uri uri = Uri.parse(schemeUrl);
        Intent intent = new Intent(Intent.ACTION_VIEW, uri);
        ComponentName componentName = intent.resolveActivity(applicationContext.getPackageManager());
        return componentName != null;
    }

    /**
     * 获取应用启动次数
     *
     * @param context 上下文
     * @return 启动次数
     */
    public static int getLaunchCount(Context context) {
        int launchCount = SharedPrefUtils.getPrefInt(context, "$_application_launch_count");
        return launchCount;
    }

    /**
     * 判断应用是否首次启动
     *
     * @param context 上下文
     * @return true-首次启动;false-非首次启动;
     */
    public static boolean isFirstLaunch(Context context) {
        int launchCount = getLaunchCount(context);
        return launchCount <= 1;
    }
}
