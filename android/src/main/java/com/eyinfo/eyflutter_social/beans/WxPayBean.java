package com.eyinfo.eyflutter_social.beans;

public class WxPayBean {

    private String appId;
    private String universalLink;
    private String partnerId;
    private String prepayId;
    private String nonceStr;
    private String timestamp;
    private String sign;

    public String getAppId() {
        return appId == null ? "" : appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }

    public String getUniversalLink() {
        return universalLink == null ? "" : universalLink;
    }

    public void setUniversalLink(String universalLink) {
        this.universalLink = universalLink;
    }

    public String getPartnerId() {
        return partnerId == null ? "" : partnerId;
    }

    public void setPartnerId(String partnerId) {
        this.partnerId = partnerId;
    }

    public String getPrepayId() {
        return prepayId == null ? "" : prepayId;
    }

    public void setPrepayId(String prepayId) {
        this.prepayId = prepayId;
    }

    public String getNonceStr() {
        return nonceStr == null ? "" : nonceStr;
    }

    public void setNonceStr(String nonceStr) {
        this.nonceStr = nonceStr;
    }

    public String getTimestamp() {
        return timestamp == null ? "" : timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getSign() {
        return sign == null ? "" : sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }
}
