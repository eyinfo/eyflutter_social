package com.eyinfo.eyflutter_social;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;

import com.alipay.sdk.app.PayTask;
import com.basic.eyflutter_core.channel.ChannelPlugin;
import com.cloud.eyutils.launchs.LauncherState;
import com.eyinfo.eyflutter_social.beans.AliPayBean;
import com.eyinfo.eyflutter_social.beans.PayResult;

import java.util.HashMap;
import java.util.Map;

public class AliPayController {

    final String aliPayStatusChannelName = "0904c07a0b33d339";

    public void payOrder(AliPayBean aliPayBean) {
        Thread payThread = new Thread(new AliPayRunnable(aliPayBean));
        payThread.start();
    }

    private class AliPayRunnable implements Runnable {

        private AliPayBean payBean;

        public AliPayRunnable(AliPayBean payBean) {
            this.payBean = payBean;
        }

        @Override
        public void run() {
            Activity currActivity = LauncherState.getInstance().getRecentlyCreateActivity();
            if (currActivity == null) {
                return;
            }
            PayTask alipay = new PayTask(currActivity);
            Map<String, String> result = alipay.payV2(payBean.getSign(), true);
            Message msg = new Message();
            msg.what = 3890;
            msg.obj = result;
            AliPayController.this.handler.sendMessage(msg);
        }
    }

    private Handler handler = new Handler(Looper.getMainLooper()) {
        public void handleMessage(Message msg) {
            if (msg.what == 3890) {
                try {
                    //9000 订单支付成功
                    //8000 正在处理中
                    //4000 订单支付失败
                    //6001 用户中途取消
                    //6002 网络连接出错
                    PayResult payResult = new PayResult((Map) msg.obj);
                    String resultInfo = payResult.getResult();
                    String resultStatus = payResult.getResultStatus();
                    HashMap<String, Object> resultMap = new HashMap<>();
                    if (TextUtils.equals(resultStatus, "9000")) {
                        resultMap.put("status", "success");
                        resultMap.put("response", resultInfo);
                    } else if (TextUtils.equals(resultStatus, "8000")) {
                        resultMap.put("status", "processing");
                        resultMap.put("response", resultInfo);
                    } else if (TextUtils.equals(resultStatus, "6001")) {
                        resultMap.put("status", "cancel");
                        resultMap.put("response", resultInfo);
                    } else if (TextUtils.equals(resultStatus, "6002")) {
                        resultMap.put("status", "disconnected");
                        resultMap.put("response", resultInfo);
                    } else {
                        resultMap.put("status", "fail");
                        resultMap.put("response", resultInfo);
                    }
                    ChannelPlugin.getInstance().invokeMethod(aliPayStatusChannelName, resultMap, null);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    };
}
