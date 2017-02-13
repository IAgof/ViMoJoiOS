# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
 use_frameworks!

def shared_pods
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Alamofire'
    pod 'Mixpanel'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'RealmSwift'
    pod 'SwifterSwift'
    
    pod 'Google/SignIn'
    pod 'Google'
    pod 'NMRangeSlider', '~> 1.2'
    pod 'TTRangeSlider'
    
    pod 'KYDrawerController'
    pod 'MBCircularProgressBar', '0.3.4'
end
target 'vimojo' do
    shared_pods
end

target 'RTVE' do
    shared_pods
end

target 'vimojoTests' do

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end



