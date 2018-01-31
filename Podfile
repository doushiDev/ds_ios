source 'https://github.com/CocoaPods/Specs.git'
project 'TouTiao.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'TouTiao' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TouTiao
  pod 'Alamofire', '~> 4.3'
  pod 'Kingfisher', '~> 3.0'
  pod 'HandyJSON', '~> 1.2.0'
  pod 'SwiftyJSON'
  pod 'ZFPlayer'
  pod 'FDFullscreenPopGesture'
  pod 'Firebase/Core'
  pod 'Firebase/AdMob'
  pod 'RealmSwift','2.8.1'
  pod 'UMengAnalytics'
  pod 'APParallaxHeader'
  pod 'SDCycleScrollView','~> 1.3'
  pod 'SnapKit', '~> 3.2.0'
  pod 'HandyJSON', '~> 1.2.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
