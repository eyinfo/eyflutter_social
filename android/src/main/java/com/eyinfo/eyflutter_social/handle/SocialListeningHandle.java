package com.eyinfo.eyflutter_social.handle;

import com.cloud.eyutils.HandlerManager;
import com.cloud.eyutils.events.RunnableParamsN;
import com.eyinfo.eyflutter_social.beans.SocialResult;
import com.eyinfo.eyflutter_social.enums.SocialCallType;
import com.eyinfo.eyflutter_social.enums.SocialType;
import com.eyinfo.eyflutter_social.events.SocialAuthShareCall;

import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import io.flutter.plugin.common.MethodChannel;

/**
 * Author lijinghuan
 * Email:ljh0576123@163.com
 * CreateTime:2019-04-30
 * Description:分享监听
 * Modifier:
 * ModifyContent:
 */
public class SocialListeningHandle implements PlatformActionListener {

    private SocialAuthShareCall call;
    private String socialPlatform;
    private SocialType socialType;
    private HashMap<String, Object> callMap = new HashMap<>();
    private MethodChannel.Result channelCall;

    public SocialListeningHandle(MethodChannel.Result result, SocialAuthShareCall call, String socialPlatform, SocialType socialType) {
        this.channelCall = result;
        this.call = call;
        this.socialPlatform = socialPlatform;
        this.socialType = socialType;
    }

    @Override
    public void onError(Platform platform, int i, Throwable throwable) {
        HandlerManager.getInstance().post(new RunnableParamsN<String>() {
            @Override
            public void run(String... params) {
                if (call != null) {
                    call.onError(SocialCallType.error, socialPlatform, socialType, params[0]);
                }
                callMap.put("callType", "fail");
                callMap.put("message", "");
                channelCall.success(callMap);
            }
        }, throwable.getMessage());
    }

    @Override
    public void onCancel(Platform platform, int i) {
        HandlerManager.getInstance().post(new RunnableParamsN<String>() {
            @Override
            public void run(String... params) {
                if (call != null) {
                    call.onCancel(SocialCallType.cancel, socialPlatform, socialType);
                }
                callMap.put("callType", "cancel");
                callMap.put("message", "");
                channelCall.success(callMap);
            }
        });
    }

    @Override
    public void onComplete(Platform platform, int i, HashMap<String, Object> hashMap) {
        HandlerManager.getInstance().post(new RunnableParamsN<String>() {
            @Override
            public void run(String... params) {
                if (call != null) {
                    SocialResult result = new SocialResult();
                    result.setSocialType(socialType);
                    result.setPlatform(socialPlatform);
                    call.onSuccess(result);

                    callMap.put("callType", "success");
                    callMap.put("message", "");
                    channelCall.success(callMap);
                }
            }
        });
    }
}
