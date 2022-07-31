package com.eyinfo.eyflutter_social.beans;

import com.eyinfo.eyflutter_social.enums.SocialType;

public class SocialResult {

    /**
     * 平台
     */
    private String platform;

    /**
     * 分享信息
     */
    private ShareInfo shareInfo;

    /**
     * 授权信息
     */
    private AuthInfo authInfo;

    /**
     * 分享、授权类型
     */
    private SocialType socialType;

    public String getPlatform() {
        return platform == null ? "" : platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public ShareInfo getShareInfo() {
        return shareInfo;
    }

    public void setShareInfo(ShareInfo shareInfo) {
        this.shareInfo = shareInfo;
    }

    public AuthInfo getAuthInfo() {
        return authInfo;
    }

    public void setAuthInfo(AuthInfo authInfo) {
        this.authInfo = authInfo;
    }

    public SocialType getSocialType() {
        return socialType;
    }

    public void setSocialType(SocialType socialType) {
        this.socialType = socialType;
    }
}
