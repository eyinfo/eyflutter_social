package com.eyinfo.eyflutter_social.enums;

/**
 * Author lijinghuan
 * Email:ljh0576123@163.com
 * CreateTime:2019-04-30
 * Description:回调类型
 * Modifier:
 * ModifyContent:
 */
public enum SocialCallType {
    /**
     * 一般指获取分享/授权信息空/配置项空
     */
    none,
    /**
     * 一般指未获取到平台
     */
    platformEmpty,
    /**
     * 未安装特定平台
     */
    noInstall,
    /**
     * 分享/授权错误
     */
    error,
    /**
     * 分享/授权被取消
     */
    cancel,
    /**
     * 网络未连接
     */
    netDisconnection
}
