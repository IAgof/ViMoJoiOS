# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
platform :ios, 9.3
use_frameworks!
inhibit_all_warnings!

def shared_pods
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Alamofire'
    pod 'Mixpanel'
    pod 'SwifterSwift', '~> 1.2'
    pod 'GoogleSignIn'
    pod 'NMRangeSlider', '~> 1.2'
	   pod 'TTRangeSlider'
    pod 'MBCircularProgressBar', '0.3.4'
    pod 'KCFloatingActionButton'
    pod 'FSPagerView'
    pod 'SnapKit', '~> 3.0.0'
    pod 'Permission/Camera'
    pod 'Permission/Microphone'
    pod 'Permission/Photos'
    
    pod 'RxCocoa',    '~> 3.0'
    pod 'Moya-ObjectMapper/RxSwift', '2.4.2'
    pod 'TransitionButton', '0.3.0'
    pod 'Whisper', '5.1.0'
end

target 'vimojo' do
    shared_pods
end

target 'RTVE' do
    shared_pods
end

target 'ElConfidencial' do
  shared_pods
end

target 'ThomsonFoundation' do
	shared_pods
end

target 'Market4News' do
  shared_pods
end

target 'vimojoUITests' do
	shared_pods
end
target 'vimojoTests' do
    shared_pods
    pod 'Quick'
    pod 'Nimble'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end
