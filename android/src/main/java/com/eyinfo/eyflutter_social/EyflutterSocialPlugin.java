package com.eyinfo.eyflutter_social;

import android.content.Context;
import android.text.TextUtils;

import com.basic.eyflutter_core.channel.ChannelPlugin;
import com.basic.eyflutter_core.channel.OnDistributionSubscribe;
import com.cloud.eyutils.mapper.MapperEntry;
import com.cloud.eyutils.toasty.ToastUtils;
import com.cloud.eyutils.utils.ConvertUtils;
import com.cloud.eyutils.utils.ObjectJudge;
import com.eyinfo.eyflutter_social.beans.AliPayBean;
import com.eyinfo.eyflutter_social.beans.ShareInfo;
import com.eyinfo.eyflutter_social.beans.SocialConfigInfo;
import com.eyinfo.eyflutter_social.beans.WxPayBean;
import com.eyinfo.eyflutter_social.enums.SocialCallType;
import com.eyinfo.eyflutter_social.enums.SocialType;
import com.eyinfo.eyflutter_social.handle.AuthShareHandle;
import com.eyinfo.eyflutter_social.handle.SocialListeningHandle;
import com.eyinfo.eyflutter_social.utils.ShareConfigUtils;
import com.mob.MobSDK;

import java.util.HashMap;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.ShareSDK;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

/**
 * EyflutterSocialPlugin
 */
public class EyflutterSocialPlugin implements FlutterPlugin {

    private Context applicationContext;
    private SocialConfigInfo socialConfigInfo;
    private boolean isInitializedMob;

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        applicationContext = binding.getApplicationContext();
        isInitializedMob = false;
        ChannelPlugin.getInstance().putSubscribe(SocialChannelKeys.initSocialMethodName, new MobInitSubscribe());
        ChannelPlugin.getInstance().putSubscribe(SocialChannelKeys.shareMethodName, new ShareSubscribe());
        ChannelPlugin.getInstance().putSubscribe(SocialChannelKeys.aliPayChannelName, new PayOrderSubscribe());
        ChannelPlugin.getInstance().putSubscribe(SocialChannelKeys.wechatPayParamsChannelName, new WechatPayParamsSubscribe());
        ChannelPlugin.getInstance().putSubscribe(SocialChannelKeys.wechatPayChannelName, new WechatPaySubscribe());
        ChannelPlugin.getInstance().putSubscribe(SocialChannelKeys.authChannelName, new AuthSubscribe());
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        ChannelPlugin.getInstance().removeSubScribe(SocialChannelKeys.initSocialMethodName);
        ChannelPlugin.getInstance().removeSubScribe(SocialChannelKeys.shareMethodName);
        ChannelPlugin.getInstance().removeSubScribe(SocialChannelKeys.aliPayChannelName);
        ChannelPlugin.getInstance().removeSubScribe(SocialChannelKeys.wechatPayParamsChannelName);
        ChannelPlugin.getInstance().removeSubScribe(SocialChannelKeys.wechatPayChannelName);
        ChannelPlugin.getInstance().removeSubScribe(SocialChannelKeys.authChannelName);
    }

    private class MobInitSubscribe extends OnDistributionSubscribe {

        @Override
        public void onSubscribe(MethodChannel.Result result, HashMap<String, Object> arguments) {
            if (ObjectJudge.isNullOrEmpty(arguments)) {
                return;
            }
            SocialConfigInfo configInfo = MapperEntry.toEntity(arguments, SocialConfigInfo.class);
            EyflutterSocialPlugin.this.socialConfigInfo = configInfo;
            if (!isInitializedMob) {
                isInitializedMob = true;
                MobSDK.init(applicationContext, configInfo.getMobAppKey());
                //https://www.mob.com/wiki/detailed?wiki=ShareSDK_Android_Title_ksjc&id=14
                MobSDK.submitPolicyGrantResult(true, null);
            }
            result.success("success");
        }
    }

    private class ShareSubscribe extends OnDistributionSubscribe {

        @Override
        public void onSubscribe(MethodChannel.Result result, HashMap<String, Object> arguments) {
            if (ObjectJudge.isNullOrEmpty(arguments)) {
                return;
            }
            ShareInfo shareInfo = MapperEntry.toEntity(arguments, ShareInfo.class);
            HashMap<String, Object> callMap = new HashMap<>();
            AuthShareHandle handle = new AuthShareHandle();
            if (shareInfo == null) {
                handle.onError(SocialCallType.none, "", SocialType.share, "分享信息为空");
                callMap.put("callType", SocialCallType.none.name());
                callMap.put("message", "分享信息为空");
                result.success(callMap);
                return;
            }
            if (socialConfigInfo == null) {
                handle.onError(SocialCallType.none, shareInfo.getPlatform(), SocialType.share, "配置信息为空");
                callMap.put("callType", SocialCallType.none.name());
                callMap.put("message", "配置信息为空");
                result.success(callMap);
                return;
            }
            ShareConfigUtils.setting(shareInfo.getPlatform(), socialConfigInfo);
            String sdkPlatform = ShareConfigUtils.getSdkPlatform(shareInfo.getPlatform());
            if (TextUtils.isEmpty(sdkPlatform)) {
                handle.onError(SocialCallType.platformEmpty, shareInfo.getPlatform(), SocialType.share, "未获取到分享平台");
                callMap.put("callType", SocialCallType.platformEmpty.name());
                callMap.put("message", "未获取到分享平台");
                result.success(callMap);
                return;
            }
            Platform platform = ShareSDK.getPlatform(sdkPlatform);
            if (platform == null) {
                handle.onError(SocialCallType.platformEmpty, shareInfo.getPlatform(), SocialType.share, "未获取到分享平台");
                callMap.put("callType", SocialCallType.platformEmpty.name());
                callMap.put("message", "未获取到分享平台");
                result.success(callMap);
                return;
            }
            if (!PrepareLogic.checkPlatformInstall(result, shareInfo.getPlatform(), handle, SocialType.share)) {
                return;
            }
            handle.onShareInfoIntercept(shareInfo);
            platform.setPlatformActionListener(new SocialListeningHandle(result, handle, shareInfo.getPlatform(), SocialType.share));
            Platform.ShareParams shareParams = PrepareLogic.prepareShareInfo(shareInfo);
            platform.share(shareParams);
            //开始唤起分享通知dart
            callMap.put("callType", "start");
            callMap.put("message", "");
            result.success(callMap);
        }
    }

    private class PayOrderSubscribe extends OnDistributionSubscribe {

        @Override
        public void onSubscribe(MethodChannel.Result result, HashMap<String, Object> arguments) {
            if (ObjectJudge.isNullOrEmpty(arguments)) {
                return;
            }
            AliPayBean entity = MapperEntry.toEntity(arguments, AliPayBean.class);
            AliPayController controller = new AliPayController();
            controller.payOrder(entity);
        }
    }

    private class WechatPayParamsSubscribe extends OnDistributionSubscribe {

        @Override
        public void onSubscribe(MethodChannel.Result result, HashMap<String, Object> arguments) {
            if (ObjectJudge.isNullOrEmpty(arguments) || !arguments.containsKey("appId")) {
                return;
            }
            BaseWxPayEntryActivity.wechatAppId = ConvertUtils.toString(arguments.get("appId"));
            result.success("success");
        }
    }

    private class WechatPaySubscribe extends OnDistributionSubscribe {

        @Override
        public void onSubscribe(MethodChannel.Result result, HashMap<String, Object> arguments) {
            WxPayBean entity = MapperEntry.toEntity(arguments, WxPayBean.class);
            if (entity == null) {
                ToastUtils.show("支付消息为空");
                return;
            }
            WxPayController controller = new WxPayController(applicationContext, entity.getAppId());
            controller.payOrder(entity);
        }
    }

    private class AuthSubscribe extends OnDistributionSubscribe {

        @Override
        public void onSubscribe(MethodChannel.Result result, HashMap<String, Object> arguments) {
            AuthController controller = new AuthController();
            controller.authorize(result, arguments);
        }
    }
}
