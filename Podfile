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
    
    pod 'SpaceOnDisk', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/SpaceOnDisk'
    pod 'BatteryRemaining', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/BatteryRemaining'
    
    pod 'ISOConfiguration', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/ISOConfiguration'
    pod 'WhiteBalance', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/WhiteBalance'
    pod 'Exposure', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/Exposure'
    pod 'AudioLevelBar', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/AudioLevelBar'
    pod 'Focus', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/Focus'
    pod 'FocalLensSlider', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/FocalLensSlider'
    pod 'ExpositionModes', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/ExpositionModes'
    pod 'ZoomCameraSlider', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/ZoomCameraSlider'
    pod 'ResolutionSelector', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/ResolutionsSelector'
    pod 'VideoGallery', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/VideoGallery'
    pod 'VideoGallery', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/VideoGallery'
    pod 'InputSoundGainControl', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/InputSoundGainControl'
    pod 'VideonaRangeSlider', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/VideonaRangeSlider'
    pod 'VideonaTrackOverView', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/VideonaTrackOverView'
    
    pod 'VideonaProject', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/VideonaProject'
    
    
    #EDITOR
    pod 'VideonaDuplicate', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/VideonaDuplicate'
    pod 'VideonaSplit', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/VideonaSplit'
    pod 'VideonaTrim', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/VideonaTrim'
    pod 'VideonaPlayer', :path => '/Users/Alejandro/Desktop/Repos/Videona_Pods/VideonaPlayer'
    
    pod 'KYDrawerController'
    
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



