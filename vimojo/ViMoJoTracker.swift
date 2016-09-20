//
// Created by Alejandro Arjonilla Garcia on 21/6/16.
// Copyright (c) 2016 Videona. All rights reserved.
//

import Foundation
import Mixpanel
import VideonaProject

class ViMoJoTracker {
    let mixpanel = Mixpanel.sharedInstanceWithToken(AnalyticsConstants().MIXPANEL_TOKEN)
    let preferences = NSUserDefaults.standardUserDefaults()
    
    static let sharedInstance = ViMoJoTracker()
    
    //MARK: - Identify Mixpanel
    func identifyMixpanel(){
        mixpanel.identify(Utils().udid)
    }

    //MARK: - Time in activity track
    func startTimeInActivityEvent(){
        mixpanel.timeEvent(AnalyticsConstants().TIME_IN_ACTIVITY)
        Utils().debugLog("Sending startTimeInActivityEvent")
    }

    func sendTimeInActivity(controllerName:String) {
        Utils().debugLog("Sending AnalyticsConstants().TIME_IN_ACTIVITY")
        //NOT WORKING -- falta el comienzo time_event para arrancar el contador

        Utils().debugLog("what class is \(controllerName)")

        let viewProperties = [AnalyticsConstants().ACTIVITY:controllerName]
        mixpanel.track(AnalyticsConstants().TIME_IN_ACTIVITY, properties: viewProperties)
        mixpanel.flush()
    }

    //MARK: - User interaction track
    func sendUserInteractedTracking(activity:String,
                                    recording:Bool,
                                    interaction:String,
                                    result:String ) {
        //JSON properties
        let userInteractionsProperties =
        [
                AnalyticsConstants().ACTIVITY : activity,
                AnalyticsConstants().RECORDING: recording,
                AnalyticsConstants().INTERACTION: interaction,
                AnalyticsConstants().RESULT: result,
        ]

        mixpanel.track(AnalyticsConstants().USER_INTERACTED, properties: userInteractionsProperties as [NSObject : AnyObject])
    }

    func sendFilterSelectedTracking(name:String,
                                    code:String,
                                    recording:Bool) {
        //JSON properties
        let userInteractionsProperties =
        [
                AnalyticsConstants().TYPE: AnalyticsConstants().FILTER_TYPE_COLOR,
                AnalyticsConstants().NAME: name,
                AnalyticsConstants().CODE: code,
                AnalyticsConstants().RECORDING: recording,
        ]

        mixpanel.track(AnalyticsConstants().FILTER_SELECTED, properties: userInteractionsProperties as [NSObject : AnyObject])
    }

    //MARK: - User
    func trackMailTraits() {
        Utils().debugLog("trackMailTraits")
        
        
        let userProfileProperties = [AnalyticsConstants().ACCOUNT_MAIL:getPreferenceStringSaved(SettingsConstants().SETTINGS_MAIL)] as [NSObject : AnyObject]
        
        mixpanel.people.set(userProfileProperties)
    }
    
    func trackNameTraits() {
        Utils().debugLog("trackNameTraits")
        
        let userProfileProperties = [AnalyticsConstants().NAME: getPreferenceStringSaved(SettingsConstants().SETTINGS_NAME)] as [NSObject : AnyObject]
        
        mixpanel.people.set(userProfileProperties)
    }
    
    func trackUserNameTraits() {
        Utils().debugLog("trackUserNameTraits")
        
        let userProfileProperties = [AnalyticsConstants().USERNAME:getPreferenceStringSaved(SettingsConstants().SETTINGS_USERNAME)] as [NSObject : AnyObject]
        
        mixpanel.people.set(userProfileProperties)
    }
    
    //MARK: - Filter selected
    func sendFilterSelectedTracking(type:String,
                                    name:String,
                                    code:String,
                                    isRecording:Bool,
                                    combined:Bool,
                                    filtersCombined:[String]) {
        //JSON properties
        let userInteractionsProperties =
            [
                AnalyticsConstants().TYPE: type,
                AnalyticsConstants().NAME: name,
                AnalyticsConstants().CODE: code,
                AnalyticsConstants().RECORDING: isRecording,
                AnalyticsConstants().COMBINED: combined,
                AnalyticsConstants().FILTERS_COMBINED: filtersCombined,
                ]
        mixpanel.track(AnalyticsConstants().FILTER_SELECTED, properties: userInteractionsProperties as [NSObject : AnyObject])
        mixpanel.people.increment(AnalyticsConstants().TOTAL_FILTERS_USED,by: NSNumber.init(int: Int32(1)))
    }
    
    //MARK: - App Shared
    func trackAppShared( appName:String,  socialNetwork:String) {
        let appSharedProperties =
            [
                AnalyticsConstants().APP_SHARED_NAME: appName,
                AnalyticsConstants().SOCIAL_NETWORK: socialNetwork
        ]
        mixpanel.track(AnalyticsConstants().APP_SHARED, properties: appSharedProperties as [NSObject : AnyObject])
    }

    //MARK: - Link Clicked
    func trackLinkClicked( uri:String,  destination:String) {
        let linkClickProperties =
            [
                AnalyticsConstants().LINK: uri,
                AnalyticsConstants().SOURCE_APP: AnalyticsConstants().SOURCE_APP_VIDEONA,
                AnalyticsConstants().DESTINATION: destination
        ]
        mixpanel.track(AnalyticsConstants().LINK_CLICK, properties: linkClickProperties as [NSObject : AnyObject])
    }
    
    //MARK: - Video Shared
    func trackVideoShared(socialNetwork:String,
                          videoDuration:Double,
                          numberOfClips:Int) {
        
        self.updateNumTotalVideosShared()

        trackVideoSharedSuperProperties()
        
        mixpanel.identify(Utils().udid)
        
        //JSON properties
        let socialNetworkProperties =
            [
                AnalyticsConstants().SOCIAL_NETWORK : socialNetwork,
                AnalyticsConstants().VIDEO_LENGTH: videoDuration,
                AnalyticsConstants().RESOLUTION: getPreferenceStringSaved(SettingsConstants().SETTINGS_RESOLUTION),
                AnalyticsConstants().NUMBER_OF_CLIPS: numberOfClips,
                AnalyticsConstants().TOTAL_VIDEOS_SHARED: getPreferenceIntSaved(ConfigPreferences().TOTAL_VIDEOS_SHARED),
                AnalyticsConstants().DOUBLE_HOUR_AND_MINUTES: Utils().getDoubleHourAndMinutes(),
                ]
        mixpanel.track(AnalyticsConstants().VIDEO_SHARED, properties: socialNetworkProperties as [NSObject : AnyObject])
        
        mixpanel.people.increment(AnalyticsConstants().TOTAL_VIDEOS_SHARED,by: NSNumber.init(int: Int32(1)))
        mixpanel.people.set(AnalyticsConstants().LAST_VIDEO_SHARED,to: Utils().giveMeTimeNow())
    }
    
    
    func trackVideoSharedSuperProperties() {
        var numPreviousVideosShared:Int
        let properties = mixpanel.currentSuperProperties()
        
        if let prop = properties[AnalyticsConstants().TOTAL_VIDEOS_SHARED]{
            numPreviousVideosShared = prop as! Int
        }else{
            numPreviousVideosShared = 0
        }
        
        numPreviousVideosShared += 1
        
        //JSON properties
        
        let updateSuperProperties = [AnalyticsConstants().TOTAL_VIDEOS_SHARED: numPreviousVideosShared]
        
        mixpanel.registerSuperProperties(updateSuperProperties)
    }
    
    //MARK: - Video Recorded
    func trackTotalVideosRecordedSuperProperty() {
        var numPreviousVideosRecorded:Int
        let properties = mixpanel.currentSuperProperties()
        
        if let prop = properties[AnalyticsConstants().TOTAL_VIDEOS_RECORDED]{
            numPreviousVideosRecorded = prop as! Int
        }else{
            numPreviousVideosRecorded = 0
        }
        
        numPreviousVideosRecorded += 1
        
        //JSON properties
        
        let totalVideoRecordedSuperProperty = [AnalyticsConstants().TOTAL_VIDEOS_RECORDED: numPreviousVideosRecorded]
        
        mixpanel.registerSuperProperties(totalVideoRecordedSuperProperty)
    }
    
    func sendVideoRecordedTracking(videoLenght:Double) {
        
        let totalVideosRecorded = getPreferenceIntSaved(ConfigPreferences().TOTAL_VIDEOS_RECORDED)
        let resolution = getPreferenceStringSaved(SettingsConstants().SETTINGS_RESOLUTION)
        
        //JSON properties
        let videoRecordedProperties =
            [
                AnalyticsConstants().VIDEO_LENGTH: videoLenght,
                AnalyticsConstants().RESOLUTION: resolution,
                AnalyticsConstants().TOTAL_VIDEOS_RECORDED: totalVideosRecorded,
                AnalyticsConstants().DOUBLE_HOUR_AND_MINUTES: Utils().getDoubleHourAndMinutes()
        ]
        mixpanel.track(AnalyticsConstants().VIDEO_RECORDED, properties: videoRecordedProperties as [NSObject : AnyObject])
        self.updateUserProfileProperties()
    }
    
    //MARK: - Video Exported
    func sendExportedVideoMetadataTracking(videoLenght:Double,
                                           numberOfClips:Int) {
        
        let resolution = getPreferenceStringSaved(SettingsConstants().SETTINGS_RESOLUTION)

        let videoRecordedProperties =
            [
                AnalyticsConstants().VIDEO_LENGTH: videoLenght,
                AnalyticsConstants().RESOLUTION: resolution,
                AnalyticsConstants().NUMBER_OF_CLIPS:numberOfClips ,
                AnalyticsConstants().DOUBLE_HOUR_AND_MINUTES: Utils().getDoubleHourAndMinutes(),
                ]
        mixpanel.track(AnalyticsConstants().VIDEO_EXPORTED, properties: videoRecordedProperties as [NSObject : AnyObject])
    }
    
    func updateUserProfileProperties() {
        Utils().debugLog("updateUserProfileProperties")
        mixpanel.identify(Utils().udid)
        
        let quality = getPreferenceStringSaved(SettingsConstants().SETTINGS_QUALITY)
        let resolution = getPreferenceStringSaved(SettingsConstants().SETTINGS_RESOLUTION)
        
        //JSON properties
        let userProfileProperties =
            [
                AnalyticsConstants().RESOLUTION: resolution,
                AnalyticsConstants().QUALITY: quality,
                ]
        
        mixpanel.people.set(userProfileProperties)
        mixpanel.people.increment(AnalyticsConstants().TOTAL_VIDEOS_RECORDED,by: NSNumber.init(int: Int32(1)))
        mixpanel.people.set([AnalyticsConstants().LAST_VIDEO_RECORDED:Utils().giveMeTimeNow()])
        
    }
    
    //MARK: - Editor
    func trackClipsReordered() {
//        let project = project?
//        
//        let eventProperties =
//            [
//                AnalyticsConstants().EDIT_ACTION: AnalyticsConstants().EDIT_ACTION_REORDER,
//                AnalyticsConstants().NUMBER_OF_CLIPS: project.numberOfClips(),
//                AnalyticsConstants().VIDEO_LENGTH: project.getDuration()
//                ]
//        
//        mixpanel.track(AnalyticsConstants().VIDEO_EDITED, properties: eventProperties as [NSObject : AnyObject])
    }
    
    func trackClipTrimmed() {
//        let project = project?
//        
//        let eventProperties =
//            [
//                AnalyticsConstants().EDIT_ACTION: AnalyticsConstants().EDIT_ACTION_TRIM,
//                AnalyticsConstants().NUMBER_OF_CLIPS: project.numberOfClips(),
//                AnalyticsConstants().VIDEO_LENGTH: project.getDuration()
//        ]
//        
//        mixpanel.track(AnalyticsConstants().VIDEO_EDITED, properties: eventProperties as [NSObject : AnyObject])
    }

    func trackClipSplitted() {
//        let project = project?
//
//        let eventProperties =
//            [
//                AnalyticsConstants().EDIT_ACTION: AnalyticsConstants().EDIT_ACTION_SPLIT,
//                AnalyticsConstants().NUMBER_OF_CLIPS: project.numberOfClips(),
//                AnalyticsConstants().VIDEO_LENGTH: project.getDuration()
//        ]
//        
//        mixpanel.track(AnalyticsConstants().VIDEO_EDITED, properties: eventProperties as [NSObject : AnyObject])
    }

    func trackClipDuplicated(nDuplicates:Int) {
//        let project = project?
//
//        let eventProperties =
//            [
//                AnalyticsConstants().EDIT_ACTION: AnalyticsConstants().EDIT_ACTION_DUPLICATE,
//                AnalyticsConstants().NUMBER_OF_DUPLICATES: nDuplicates,
//                AnalyticsConstants().VIDEO_LENGTH: project.getDuration()
//        ]
//        
//        mixpanel.track(AnalyticsConstants().VIDEO_EDITED, properties: eventProperties as [NSObject : AnyObject])
    }
    
    func trackMusicSet() {
//        let project = project?
//
//        let musicTitle = project.getMusic().getTitle();
//
//        let eventProperties =
//            [
//                AnalyticsConstants().EDIT_ACTION: AnalyticsConstants().EDIT_ACTION_MUSIC_SET,
//                AnalyticsConstants().NUMBER_OF_CLIPS: project.numberOfClips(),
//                AnalyticsConstants().VIDEO_LENGTH: project.getDuration(),
//                AnalyticsConstants().MUSIC_TITLE: musicTitle
//        ]
//        
//        mixpanel.track(AnalyticsConstants().VIDEO_EDITED, properties: eventProperties as [NSObject : AnyObject])
    }
    
    //MARK: - Google Analytics
//    func sendControllerGAITracker(controllerName:String){
//        Utils().debugLog("Send controller GoogleAnalytics Tracking")
//
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker.set(kGAIScreenName, value: controllerName)
//
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker.send(builder.build() as [NSObject : AnyObject])
//    }
    
    //MARK: - Get saved params
    private func getPreferenceStringSaved(preference:String) -> String {
        var preferenceSaved = ""
        if preferences.stringForKey(preference) != nil {
            preferenceSaved = preferences.stringForKey(preference)!
            
        }
        return preferenceSaved
    }
    
    private func getPreferenceIntSaved(preference:String) -> Int {
        var preferenceSaved = 0
        if preferences.objectForKey(preference) != nil {
            preferenceSaved = preferences.integerForKey(preference)
            
        }
        return preferenceSaved
    }
    
    //MARK: - Update params
    func updateTotalVideosRecorded() {
        var numTotalVideosRecorded = preferences.integerForKey(ConfigPreferences().TOTAL_VIDEOS_RECORDED)
        numTotalVideosRecorded += 1
        
        preferences.setInteger(numTotalVideosRecorded, forKey: ConfigPreferences().TOTAL_VIDEOS_RECORDED)
    }
    
    func updateNumTotalVideosShared(){
        var totalVideosShared = preferences.integerForKey(ConfigPreferences().TOTAL_VIDEOS_SHARED)
        totalVideosShared += 1
        preferences.setInteger(totalVideosShared, forKey: ConfigPreferences().TOTAL_VIDEOS_SHARED)
    }
}
