package com.eyinfo.eyflutter_social;

import android.content.Context;
import android.text.TextUtils;

import com.cloud.eyutils.logs.Logger;
import com.cloud.eyutils.toasty.ToastUtils;
import com.cloud.eyutils.utils.JsonUtils;
import com.eyinfo.eyflutter_social.beans.WxPayBean;
import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

public class WxPayController {

    private Context context;
    private IWXAPI api;

    public String APP_ID = "";

    public WxPayController(Context context, String APP_ID) {
        this.context = context;
        if (TextUtils.isEmpty(APP_ID)) {
            ToastUtils.show("支付APP ID不能为空");
            return;
        }
        this.APP_ID = APP_ID;
        api = WXAPIFactory.createWXAPI(context, APP_ID);
        // 在支付之前，如果应用没有注册到微信，应该先调用IWXMsg.registerApp将应用注册到微信
        api.registerApp(APP_ID);
    }

    public void payOrder(WxPayBean wxPayBean) {
        if (wxPayBean != null) {
            PayReq req = new PayReq();
            req.appId = wxPayBean.getAppId();
            req.partnerId = wxPayBean.getPartnerId();
            req.prepayId = wxPayBean.getPrepayId();
            req.packageValue = "Sign=WXPay";
            req.sign = wxPayBean.getSign();
            req.nonceStr = wxPayBean.getNonceStr();
            req.timeStamp = wxPayBean.getTimestamp();
            req.extData = "28021";
            api.sendReq(req);
        } else {
            Logger.error(String.format("WxPayBean参数异常:%s", JsonUtils.toJson(wxPayBean)));
        }
    }
}
