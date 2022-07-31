package com.eyinfo.eyflutter_social.beans;

public class SocialConfigInfo {

    private String mobAppKey;
    private String mobAppSecret;
    private String sinaAppKey;
    private String sinaAppSecret;
    private String sinaRedirectUrl;
    private String wechatAppId;
    private String wechatAppSecret;
    private String qqAppId;
    private String qqAppKey;

    public String getMobAppKey() {
        return mobAppKey == null ? "" : mobAppKey;
    }

    public void setMobAppKey(String mobAppKey) {
        this.mobAppKey = mobAppKey;
    }

    public String getMobAppSecret() {
        return mobAppSecret == null ? "" : mobAppSecret;
    }

    public void setMobAppSecret(String mobAppSecret) {
        this.mobAppSecret = mobAppSecret;
    }

    public String getSinaAppKey() {
        return sinaAppKey == null ? "" : sinaAppKey;
    }

    public void setSinaAppKey(String sinaAppKey) {
        this.sinaAppKey = sinaAppKey;
    }

    public String getSinaAppSecret() {
        return sinaAppSecret == null ? "" : sinaAppSecret;
    }

    public void setSinaAppSecret(String sinaAppSecret) {
        this.sinaAppSecret = sinaAppSecret;
    }

    public String getSinaRedirectUrl() {
        return sinaRedirectUrl == null ? "" : sinaRedirectUrl;
    }

    public void setSinaRedirectUrl(String sinaRedirectUrl) {
        this.sinaRedirectUrl = sinaRedirectUrl;
    }

    public String getWechatAppId() {
        return wechatAppId == null ? "" : wechatAppId;
    }

    public void setWechatAppId(String wechatAppId) {
        this.wechatAppId = wechatAppId;
    }

    public String getWechatAppSecret() {
        return wechatAppSecret == null ? "" : wechatAppSecret;
    }

    public void setWechatAppSecret(String wechatAppSecret) {
        this.wechatAppSecret = wechatAppSecret;
    }

    public String getQqAppId() {
        return qqAppId == null ? "" : qqAppId;
    }

    public void setQqAppId(String qqAppId) {
        this.qqAppId = qqAppId;
    }

    public String getQqAppKey() {
        return qqAppKey == null ? "" : qqAppKey;
    }

    public void setQqAppKey(String qqAppKey) {
        this.qqAppKey = qqAppKey;
    }
}
