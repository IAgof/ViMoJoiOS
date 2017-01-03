//
// Created by Alejandro Arjonilla Garcia on 21/6/16.
// Copyright (c) 2016 Videona. All rights reserved.
//

import Foundation
import Mixpanel
import VideonaProject

class ViMoJoTracker {
    let mixpanel = Mixpanel.sharedInstance(withToken: AnalyticsConstants().MIXPANEL_TOKEN)
    let preferences = UserDefaults.standard
    var project:Project?
    
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

    func sendTimeInActivity(_ controllerName:String) {
        Utils().debugLog("Sending AnalyticsConstants().TIME_IN_ACTIVITY")
        //NOT WORKING -- falta el comienzo time_event para arrancar el contador

        Utils().debugLog("what class is \(controllerName)")

        let viewProperties = [AnalyticsConstants().ACTIVITY:controllerName]
        mixpanel.track(AnalyticsConstants().TIME_IN_ACTIVITY, properties: viewProperties)
        mixpanel.flush()
    }

    //MARK: - User interaction track
    func sendUserInteractedTracking(_ activity:String,
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
        ] as [String : Any]

        mixpanel.track(AnalyticsConstants().USER_INTERACTED, properties: userInteractionsProperties as [AnyHashable: Any])
    }

    func sendFilterSelectedTracking(_ name:String,
                                    code:String,
                                    recording:Bool) {
        //JSON properties
        let userInteractionsProperties =
        [
                AnalyticsConstants().TYPE: AnalyticsConstants().FILTER_TYPE_COLOR,
                AnalyticsConstants().NAME: name,
                AnalyticsConstants().CODE: code,
                AnalyticsConstants().RECORDING: recording,
        ] as [String : Any]

        mixpanel.track(AnalyticsConstants().FILTER_SELECTED, properties: userInteractionsProperties as [AnyHashable: Any])
    }

    //MARK: - User
    func trackMailTraits() {
        Utils().debugLog("trackMailTraits")
        
        
        let userProfileProperties = [AnalyticsConstants().ACCOUNT_MAIL:getPreferenceStringSaved(SettingsConstants().SETTINGS_MAIL)] as [AnyHashable: Any]
        
        mixpanel.people.set(userProfileProperties)
    }
    
    func trackNameTraits() {
        Utils().debugLog("trackNameTraits")
        
        let userProfileProperties = [AnalyticsConstants().NAME: getPreferenceStringSaved(SettingsConstants().SETTINGS_NAME)] as [AnyHashable: Any]
        
        mixpanel.people.set(userProfileProperties)
    }
    
    func trackUserNameTraits() {
        Utils().debugLog("trackUserNameTraits")
        
        let userProfileProperties = [AnalyticsConstants().USERNAME:getPreferenceStringSaved(SettingsConstants().SETTINGS_USERNAME)] as [AnyHashable: Any]
        
        mixpanel.people.set(userProfileProperties)
    }
    
    //MARK: - Filter selected
    func sendFilterSelectedTracking(_ type:String,
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
                ] as [String : Any]
        mixpanel.track(AnalyticsConstants().FILTER_SELECTED, properties: userInteractionsProperties as [AnyHashable: Any])
        mixpanel.people.increment(AnalyticsConstants().TOTAL_FILTERS_USED,by: NSNumber.init(value: Int32(1) as Int32))
    }
    
    //MARK: - App Shared
    func trackAppShared( _ appName:String,  socialNetwork:String) {
        let appSharedProperties =
            [
                AnalyticsConstants().APP_SHARED_NAME: appName,
                AnalyticsConstants().SOCIAL_NETWORK: socialNetwork
        ]
        mixpanel.track(AnalyticsConstants().APP_SHARED, properties: appSharedProperties as [AnyHashable: Any])
    }

    //MARK: - Link Clicked
    func trackLinkClicked( _ uri:String,  destination:String) {
        let linkClickProperties =
            [
                AnalyticsConstants().LINK: uri,
                AnalyticsConstants().SOURCE_APP: AnalyticsConstants().SOURCE_APP_VIDEONA,
                AnalyticsConstants().DESTINATION: destination
        ]
        mixpanel.track(AnalyticsConstants().LINK_CLICK, properties: linkClickProperties as [AnyHashable: Any])
    }
    
    //MARK: - Video Shared
    func trackVideoShared(_ socialNetwork:String,
                          videoDuration:Double,
                          numberOfClips:Int) {
        
        self.updateNumTotalVideosShared()

        trackVideoSharedSuperProperties()
        
        mixpanel.identify(Utils().udid)
        
        guard let resolution = project?.getProfile().getResolution() else {return}

        //JSON properties
        let socialNetworkProperties =
            [
                AnalyticsConstants().SOCIAL_NETWORK : socialNetwork,
                AnalyticsConstants().VIDEO_LENGTH: videoDuration,
                AnalyticsConstants().RESOLUTION: resolution,
                AnalyticsConstants().NUMBER_OF_CLIPS: numberOfClips,
                AnalyticsConstants().TOTAL_VIDEOS_SHARED: getPreferenceIntSaved(ConfigPreferences().TOTAL_VIDEOS_SHARED),
                AnalyticsConstants().DOUBLE_HOUR_AND_MINUTES: Utils().getDoubleHourAndMinutes(),
                ] as [String : Any]
        mixpanel.track(AnalyticsConstants().VIDEO_SHARED, properties: socialNetworkProperties as [AnyHashable: Any])
        
        mixpanel.people.increment(AnalyticsConstants().TOTAL_VIDEOS_SHARED,by: NSNumber.init(value: Int32(1) as Int32))
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
    
    func sendVideoRecordedTracking(_ videoLenght:Double) {
        
        let totalVideosRecorded = getPreferenceIntSaved(ConfigPreferences().TOTAL_VIDEOS_RECORDED)
        guard let resolution = project?.getProfile().getResolution() else {return}
        
        //JSON properties
        let videoRecordedProperties =
            [
                AnalyticsConstants().VIDEO_LENGTH: videoLenght,
                AnalyticsConstants().RESOLUTION: resolution,
                AnalyticsConstants().TOTAL_VIDEOS_RECORDED: totalVideosRecorded,
                AnalyticsConstants().DOUBLE_HOUR_AND_MINUTES: Utils().getDoubleHourAndMinutes()
        ] as [String : Any]
        mixpanel.track(AnalyticsConstants().VIDEO_RECORDED, properties: videoRecordedProperties as [AnyHashable: Any])
        self.updateUserProfileProperties()
    }
    
    //MARK: - Video Exported
    func sendExportedVideoMetadataTracking(_ videoLenght:Double,
                                           numberOfClips:Int) {
        
        guard let resolution = project?.getProfile().getResolution() else {return}

        let videoRecordedProperties =
            [
                AnalyticsConstants().VIDEO_LENGTH: videoLenght,
                AnalyticsConstants().RESOLUTION: resolution,
                AnalyticsConstants().NUMBER_OF_CLIPS:numberOfClips ,
                AnalyticsConstants().DOUBLE_HOUR_AND_MINUTES: Utils().getDoubleHourAndMinutes(),
                ] as [String : Any]
        mixpanel.track(AnalyticsConstants().VIDEO_EXPORTED, properties: videoRecordedProperties as [AnyHashable: Any])
    }
    
    func updateUserProfileProperties() {
        Utils().debugLog("updateUserProfileProperties")
        mixpanel.identify(Utils().udid)
        
        guard let quality = project?.getProfile().getQuality() else {return}
        guard let resolution = project?.getProfile().getResolution() else {return}

        //JSON properties
        let userProfileProperties =
            [
                AnalyticsConstants().RESOLUTION: resolution,
                AnalyticsConstants().QUALITY: quality,
                ]
        
        mixpanel.people.set(userProfileProperties)
        mixpanel.people.increment(AnalyticsConstants().TOTAL_VIDEOS_RECORDED,by: NSNumber.init(value: Int32(1) as Int32))
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

    func trackClipDuplicated(_ nDuplicates:Int) {
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
    fileprivate func getPreferenceStringSaved(_ preference:String) -> String {
        var preferenceSaved = ""
        if preferences.string(forKey: preference) != nil {
            preferenceSaved = preferences.string(forKey: preference)!
            
        }
        return preferenceSaved
    }
    
    fileprivate func getPreferenceIntSaved(_ preference:String) -> Int {
        var preferenceSaved = 0
        if preferences.object(forKey: preference) != nil {
            preferenceSaved = preferences.integer(forKey: preference)
            
        }
        return preferenceSaved
    }
    
    //MARK: - Update params
    func updateTotalVideosRecorded() {
        var numTotalVideosRecorded = preferences.integer(forKey: ConfigPreferences().TOTAL_VIDEOS_RECORDED)
        numTotalVideosRecorded += 1
        
        preferences.set(numTotalVideosRecorded, forKey: ConfigPreferences().TOTAL_VIDEOS_RECORDED)
    }
    
    func updateNumTotalVideosShared(){
        var totalVideosShared = preferences.integer(forKey: ConfigPreferences().TOTAL_VIDEOS_SHARED)
        totalVideosShared += 1
        preferences.set(totalVideosShared, forKey: ConfigPreferences().TOTAL_VIDEOS_SHARED)
    }
}
