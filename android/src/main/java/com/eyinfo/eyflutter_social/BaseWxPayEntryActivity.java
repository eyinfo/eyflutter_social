package com.eyinfo.eyflutter_social;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.basic.eyflutter_core.channel.ChannelPlugin;
import com.cloud.eyutils.HandlerManager;
import com.cloud.eyutils.events.RunnableParamsN;
import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.util.HashMap;

public class BaseWxPayEntryActivity extends Activity implements IWXAPIEventHandler {

    private IWXAPI api;
    public static String wechatAppId = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        api = WXAPIFactory.createWXAPI(this, wechatAppId);
        api.handleIntent(getIntent(), this);
        finishedPage();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        api.handleIntent(intent, this);
        finishedPage();
    }

    private void finishedPage() {
        HandlerManager.getInstance().postDelayed(new RunnableParamsN<Object>() {
            @Override
            public void run(Object... objects) {
                finish();
            }
        }, 500);
    }

    @Override
    public void onReq(BaseReq baseReq) {

    }

    @Override
    public void onResp(BaseResp baseResp) {
        if (baseResp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX) {
            HashMap<String, Object> resultParams = new HashMap<>();
            if (baseResp.errCode == BaseResp.ErrCode.ERR_OK) {
                resultParams.put("status", "wx_pay_success");
                resultParams.put("response", "支付成功");
                ChannelPlugin.getInstance().invokeMethod(SocialChannelKeys.wechatPayResponseChannelName, resultParams, null);
            } else if (baseResp.errCode == BaseResp.ErrCode.ERR_COMM) {
                resultParams.put("status", "wx_pay_fail");
                resultParams.put("response", "支付异常请重试");
                ChannelPlugin.getInstance().invokeMethod(SocialChannelKeys.wechatPayResponseChannelName, resultParams, null);
            } else if (baseResp.errCode == BaseResp.ErrCode.ERR_SENT_FAILED) {
                resultParams.put("status", "wx_pay_fail");
                resultParams.put("response", "支付请求发送失败请重试");
                ChannelPlugin.getInstance().invokeMethod(SocialChannelKeys.wechatPayResponseChannelName, resultParams, null);
            } else if (baseResp.errCode == BaseResp.ErrCode.ERR_AUTH_DENIED) {
                resultParams.put("status", "wx_pay_fail");
                resultParams.put("response", "微信授权失败");
                ChannelPlugin.getInstance().invokeMethod(SocialChannelKeys.wechatPayResponseChannelName, resultParams, null);
            } else if (baseResp.errCode == BaseResp.ErrCode.ERR_UNSUPPORT) {
                resultParams.put("status", "wx_pay_fail");
                resultParams.put("response", "微信不支持或版本太低");
                ChannelPlugin.getInstance().invokeMethod(SocialChannelKeys.wechatPayResponseChannelName, resultParams, null);
            } else if (baseResp.errCode == BaseResp.ErrCode.ERR_USER_CANCEL) {
                resultParams.put("status", "wx_pay_cancel");
                resultParams.put("response", "支付已取消");
                ChannelPlugin.getInstance().invokeMethod(SocialChannelKeys.wechatPayResponseChannelName, resultParams, null);
            }
            wechatAppId = "";
        }
    }
}
