package com.eyinfo.eyflutter_social.handle;

import com.eyinfo.eyflutter_social.beans.ShareInfo;
import com.eyinfo.eyflutter_social.beans.SocialResult;
import com.eyinfo.eyflutter_social.enums.SocialCallType;
import com.eyinfo.eyflutter_social.enums.SocialType;
import com.eyinfo.eyflutter_social.events.SocialAuthShareCall;

public class AuthShareHandle implements SocialAuthShareCall {

    @Override
    public void onShareInfoIntercept(ShareInfo shareInfo) {

    }

    @Override
    public void onError(SocialCallType callType, String platformName, SocialType socialType, String message) {

    }

    @Override
    public void onCancel(SocialCallType callType, String platformName, SocialType socialType) {

    }

    @Override
    public void onSuccess(SocialResult result) {

    }
}
