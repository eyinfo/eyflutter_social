package com.eyinfo.eyflutter_social.events;

import com.eyinfo.eyflutter_social.beans.ShareInfo;
import com.eyinfo.eyflutter_social.beans.SocialResult;
import com.eyinfo.eyflutter_social.enums.SocialCallType;
import com.eyinfo.eyflutter_social.enums.SocialType;

/**
 * Author lijinghuan
 * Email:ljh0576123@163.com
 * CreateTime:2019-04-30
 * Description:分享回调
 * Modifier:
 * ModifyContent:
 */
public interface SocialAuthShareCall {

    /**
     * 分享信息拦截
     *
     * @param shareInfo 分享信息
     */
    public void onShareInfoIntercept(ShareInfo shareInfo);

    /**
     * 分享/授权失败回调
     *
     * @param callType     回调类型
     * @param platformName 平台名称
     * @param socialType   分享、授权类型
     * @param message      异常消息
     */
    public void onError(SocialCallType callType, String platformName, SocialType socialType, String message);

    /**
     * 分享/授权被取消
     *
     * @param callType     回调类型
     * @param platformName 平台名称
     * @param socialType   分享、授权类型
     */
    public void onCancel(SocialCallType callType, String platformName, SocialType socialType);

    /**
     * 分享/授权成功
     *
     * @param result 分享、授权结果
     */
    public void onSuccess(SocialResult result);
}
