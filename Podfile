# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'AceHighShowdown' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AceHighShowdown
  pod 'Google-Mobile-Ads-SDK'

end

# 現行Xcodeでは iOS 15 未満のデプロイターゲットがビルドエラーになるため、Pods 側を揃える
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 15.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
