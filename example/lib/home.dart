import 'package:eyflutter_core/eyflutter_core.dart';
import 'package:eyflutter_social/eyflutter_social.dart';
import 'package:eyflutter_social_example/share_info_impl.dart';
import 'package:eyflutter_social_example/social_config.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eyflutter demo'),
      ),
      body: ConstListView(
        itemCount: 20,
        itemExtent: 50,
        buttons: [
          ConstButton(
            text: "分享组件",
            onLongPress: () {
              share(context);
            },
          ),
        ],
      ),
    );
  }
}

void share(BuildContext context) {
  ShareDialog.instance.show(
      context: context,
      platforms: [SharePlatform.weixin],
      shareInfoCall: ShareInfoImpl(
        title: "分享测试",
        shareType: ShareType.links,
        url: "https://www.baidu.com",
        channel: "eyinfo",
      ),
      socialConfig: SocialConfig());
}
