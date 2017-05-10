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
        
        //JSON properties
        let socialNetworkProperties =
            [
                AnalyticsConstants().SOCIAL_NETWORK : socialNetwork,
                AnalyticsConstants().VIDEO_LENGTH: videoDuration,
                AnalyticsConstants().RESOLUTION: getResolutionFromProject(),
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
        
        let totalVideoRecordedSuperProperty = [AnalyticsConstants().TOTAL_VIDEOS_RECORDED: numPreviousVideosRecorded]
        
        mixpanel.registerSuperProperties(totalVideoRecordedSuperProperty)
    }
    
    func sendVideoRecordedTracking(_ videoLenght:Double) {
        
        let totalVideosRecorded = getPreferenceIntSaved(ConfigPreferences().TOTAL_VIDEOS_RECORDED)

        let videoRecordedProperties =
            [
                AnalyticsConstants().VIDEO_LENGTH: videoLenght,
                AnalyticsConstants().RESOLUTION: getResolutionFromProject(),
                AnalyticsConstants().TOTAL_VIDEOS_RECORDED: totalVideosRecorded,
                AnalyticsConstants().DOUBLE_HOUR_AND_MINUTES: Utils().getDoubleHourAndMinutes()
        ] as [String : Any]
        mixpanel.track(AnalyticsConstants().VIDEO_RECORDED, properties: videoRecordedProperties)
        self.updateUserProfileProperties()
    }
    
    //MARK: - Video Exported
    func sendExportedVideoMetadataTracking(_ videoLenght:Double,
                                           numberOfClips:Int) {
        

        let videoRecordedProperties =
            [
                AnalyticsConstants().VIDEO_LENGTH: videoLenght,
                AnalyticsConstants().RESOLUTION: getResolutionFromProject(),
                AnalyticsConstants().NUMBER_OF_CLIPS:numberOfClips ,
                AnalyticsConstants().DOUBLE_HOUR_AND_MINUTES: Utils().getDoubleHourAndMinutes(),
                ] as [String : Any]
        mixpanel.track(AnalyticsConstants().VIDEO_EXPORTED, properties: videoRecordedProperties)
    }
    
    func updateUserProfileProperties() {
        Utils().debugLog("updateUserProfileProperties")
        mixpanel.identify(Utils().udid)
        
        guard let quality = project?.getProfile().getQuality() else {return}

        //JSON properties
        let userProfileProperties =
            [
                AnalyticsConstants().RESOLUTION: getResolutionFromProject(),
                AnalyticsConstants().QUALITY: quality,
                ]
        
        mixpanel.people.set(userProfileProperties)
        mixpanel.people.increment(AnalyticsConstants().TOTAL_VIDEOS_RECORDED,by: NSNumber.init(value: Int32(1) as Int32))
        mixpanel.people.set([AnalyticsConstants().LAST_VIDEO_RECORDED:Utils().giveMeTimeNow()])
    }
    
    //MARK: - Editor
    func trackClipsReordered() {
        var eventProperties =
            [
                AnalyticsConstants().EDIT_ACTION: AnalyticsConstants().EDIT_ACTION_REORDER
                ] as [String : Any]
        addProjectEventProperties(objectJSON: &eventProperties)

        mixpanel.track(AnalyticsConstants().VIDEO_EDITED, properties: eventProperties)
    }
    
    func trackClipTrimmed() {
        var eventProperties =
            [
                AnalyticsConstants().EDIT_ACTION: AnalyticsConstants().EDIT_ACTION_TRIM
        ] as [String : Any]
        addProjectEventProperties(objectJSON: &eventProperties)

        mixpanel.track(AnalyticsConstants().VIDEO_EDITED, properties: eventProperties )
    }

    func trackClipSplitted() {
        var eventProperties =
            [
                AnalyticsConstants().EDIT_ACTION: AnalyticsConstants().EDIT_ACTION_SPLIT
                ] as [String : Any]
        addProjectEventProperties(objectJSON: &eventProperties)

        mixpanel.track(AnalyticsConstants().VIDEO_EDITED, properties: eventProperties)
    }

    func trackClipDuplicated(_ nDuplicates:Int) {
        var eventProperties =
            [
                AnalyticsConstants().EDIT_ACTION: AnalyticsConstants().EDIT_ACTION_DUPLICATE,
                AnalyticsConstants().NUMBER_OF_DUPLICATES: nDuplicates
        ] as [String : Any]
        addProjectEventProperties(objectJSON: &eventProperties)
        mixpanel.track(AnalyticsConstants().VIDEO_EDITED, properties: eventProperties)
    }
    
    func trackMusicSet() {
        guard let project = project else{return}

        let musicTitle = project.getMusic().getTitle();

        var eventProperties =
            [
                AnalyticsConstants().EDIT_ACTION: AnalyticsConstants().EDIT_ACTION_MUSIC_SET,
                AnalyticsConstants().MUSIC_TITLE: musicTitle
        ] as [String : Any]
        addProjectEventProperties(objectJSON: &eventProperties)
        mixpanel.track(AnalyticsConstants().VIDEO_EDITED, properties: eventProperties)
    }
    
    func trackClipAddedText(position:String,
                            textLength:Int) {
        var eventProperties =
            [
                AnalyticsConstants().EDIT_ACTION: AnalyticsConstants().EDIT_ACTION_TEXT,
                AnalyticsConstants().TEXT_POSITION: position,
                AnalyticsConstants().TEXT_LENGTH: textLength
                ] as [String : Any]
        addProjectEventProperties(objectJSON: &eventProperties)
        mixpanel.track(AnalyticsConstants().VIDEO_EDITED, properties: eventProperties)
    }
    
    func trackVoiceOverAdded() {
        guard let project = project else{return}
        guard let volume = project.voiceOver.first?.audioLevel else{return}
        
        var eventProperties =
            [
                AnalyticsConstants().EDIT_ACTION: AnalyticsConstants().EDIT_ACTION_VOICE_OVER,
                AnalyticsConstants().VOLUME_SET: volume
                ] as [String : Any]
        addProjectEventProperties(objectJSON: &eventProperties)
        mixpanel.track(AnalyticsConstants().VIDEO_EDITED, properties: eventProperties)
    }
    
    func addProjectEventProperties(objectJSON:inout [String : Any]){
        guard let project = project else{return}

        objectJSON[AnalyticsConstants().NUMBER_OF_CLIPS] = project.numberOfClips()
        objectJSON[AnalyticsConstants().VIDEO_LENGTH] = project.getDuration()
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
    
    func getResolutionFromProject()->String{
        guard let resolution = project?.getProfile().getResolution() else {return ""}
        return AVResolutionParse().parseResolutionToView(resolution)
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
    
    //MARK: - Start app
    func sendStartupAppTracking(initState state:String) {
        let initAppProperties = [AnalyticsConstants().TYPE:AnalyticsConstants().TYPE_ORGANIC,
                                 AnalyticsConstants().INIT_STATE:state,
                                 AnalyticsConstants().DOUBLE_HOUR_AND_MINUTES: Utils().getDoubleHourAndMinutes()] as [String : Any]
        mixpanel.track(AnalyticsConstants().APP_STARTED, properties: initAppProperties)
    }
    
    func trackAppStartupProperties(_ state:Bool) {
        Utils().debugLog("trackAppStartupProperties")
        mixpanel.identify(Utils().udid)
        
        var appUseCount:Int
        let properties = mixpanel.currentSuperProperties()
        if let count = properties[AnalyticsConstants().APP_USE_COUNT]{
            appUseCount = count as! Int
        }else{
            appUseCount = 0
        }
        appUseCount += 1
        
        Utils().debugLog("App USE COUNT \(appUseCount)")
        
        let appStartupSuperProperties = [AnalyticsConstants().APP_USE_COUNT:NSNumber.init(value: Int32(appUseCount) as Int32),
                                         AnalyticsConstants().FIRST_TIME:state,
                                         AnalyticsConstants().APP: AnalyticsConstants().APP_NAME] as [String : Any]
        mixpanel.registerSuperProperties(appStartupSuperProperties as [AnyHashable: Any])
    }
    
    func trackUserProfile() {
        Utils().debugLog("The user id is = \(Utils().udid)")
        
        mixpanel.identify(Utils().udid)
        let userProfileProperties = [AnalyticsConstants().CREATED:Utils().giveMeTimeNow()]
        mixpanel.people.setOnce(userProfileProperties)
    }
    
    func trackUserProfileGeneralTraits() {
        mixpanel.identify(Utils().udid)
        
        Utils().debugLog("trackUserProfileGeneralTraits")
        
        let increment:NSNumber = NSNumber.init(value: 1 as Int)
        Utils().debugLog("App USE COUNT Increment by: \(increment)")
        
        mixpanel.people.increment(AnalyticsConstants().APP_USE_COUNT,by: increment)
        
        let locale = Locale.preferredLanguages[0]
        
        //        let lang = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)
        let langISO = (Locale.current as NSLocale).iso639_2LanguageCode()
        let userProfileProperties = [AnalyticsConstants().TYPE:AnalyticsConstants().USER_TYPE_FREE,
                                     AnalyticsConstants().LOCALE:locale,
                                     AnalyticsConstants().LANG: langISO!] as [AnyHashable: Any]
        
        mixpanel.people.set(userProfileProperties)
    }
    
    func trackCreatedSuperProperty() {
        let createdSuperProperty = [AnalyticsConstants().CREATED: Utils().giveMeTimeNow()]
        mixpanel.registerSuperPropertiesOnce(createdSuperProperty)
    }
}
