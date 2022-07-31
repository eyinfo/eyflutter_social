//
//  ShareInfo.swift
//  cloud_basic_social
//
//  Created by 李敬欢 on 2020/11/24.
//

import Foundation

struct ShareInfo {
    // 平台名称
    var platform = "";
    // 分享渠道
    var channel = "";
    // 分享标题
    var title = "";
    // 描述信息(即分享内容)
    var describe = "";
    // 分享类型
    var shareType = "";
    // 根据分享类型：ShareType.image-图片url,ShareType.links-分享网页url,ShareType.text-该项为空
    var url = "";
    // 图片链接
    var imageUrl = "";
    // 扩展参数
    var extras:AnyObject?;
    // 回调key
    var callKey = "";
}
