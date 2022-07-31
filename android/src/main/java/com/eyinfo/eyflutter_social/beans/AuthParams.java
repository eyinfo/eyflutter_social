package com.eyinfo.eyflutter_social.beans;

//接收授权参数
public class AuthParams {

    /**
     * 平台名称
     */
    private String platform;

    public String getPlatform() {
        return platform == null ? "" : platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }
}
