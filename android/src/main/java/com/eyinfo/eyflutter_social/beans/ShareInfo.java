package com.eyinfo.eyflutter_social.beans;

/**
 * Author lijinghuan
 * Email:ljh0576123@163.com
 * CreateTime:2019-04-30
 * Description:分享信息
 * 新浪微博:describe[text],imageUrl[imagePath]
 * Modifier:
 * ModifyContent:
 */
public class ShareInfo {
    /**
     * 平台名称
     */
    private String platform;
    /**
     * 分享渠道
     */
    private String channel;
    /**
     * 分享标题
     */
    private String title;
    /**
     * 描述信息(即分享内容)
     */
    private String describe;
    /**
     * 分享类型
     */
    private String shareType;
    /**
     * 根据分享类型：ShareType.image-图片url,ShareType.links-分享网页url,ShareType.text-该项为空
     */
    private String url;
    /**
     * 图片链接
     */
    private String imageUrl;
    /**
     * 扩展参数
     */
    private Object extras;

    public String getPlatform() {
        return platform == null ? "" : platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public String getChannel() {
        return channel == null ? "" : channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public String getTitle() {
        return title == null ? "" : title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescribe() {
        return describe == null ? "" : describe;
    }

    public void setDescribe(String describe) {
        this.describe = describe;
    }

    public String getShareType() {
        return shareType == null ? "" : shareType;
    }

    public void setShareType(String shareType) {
        this.shareType = shareType;
    }

    public String getUrl() {
        return url == null ? "" : url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getImageUrl() {
        return imageUrl == null ? "" : imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Object getExtras() {
        return extras == null ? extras = new Object() : extras;
    }

    public void setExtras(Object extras) {
        this.extras = extras;
    }
}
