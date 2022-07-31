#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint eyflutter_social.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'eyflutter_social'
  s.version          = '0.0.1'
  s.summary          = 'eyinfo social plug in'
  s.description      = <<-DESC
eyinfo social plug in
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.dependency 'eyflutter_core'
  s.dependency 'eyflutter_uikit'
  s.dependency 'mob_sharesdk'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/QQ'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
  s.dependency 'mob_sharesdk/ShareSDKPlatforms/WeChatFull'
  s.dependency 'mob_sharesdk/ShareSDKExtension'
  s.dependency 'AlipaySDK-iOS'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
