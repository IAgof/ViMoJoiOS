//
//  AppDelegate.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 5/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import Mixpanel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appDependencies = AppDependencies()
    var initState = "firstTime"
    var mixpanel:Mixpanel?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //MIXPANEL
        mixpanel = Mixpanel.sharedInstanceWithToken(AnalyticsConstants().MIXPANEL_TOKEN)
        
        self.setupStartApp()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    //MARK: - Inner functions
    func setupStartApp() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let currentAppVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let previousVersion = defaults.stringForKey("appVersion")
        
        if previousVersion == nil {
            // first launch
            defaults.setObject(currentAppVersion, forKey: "appVersion")
            defaults.synchronize()
            
            Utils().debugLog("setupStartApp First time")
            initState = "firstTime"
            
            trackUserProfile();
            trackCreatedSuperProperty();
            trackAppStartupProperties(true);
            
            self.configureQualityOnFirstIteration()
            
            appDependencies.installRecordToRootViewControllerIntoWindow(window!)
        } else if previousVersion == currentAppVersion {
            // same version
            Utils().debugLog("setupStartApp Same version")
            initState = "returning"
            
            trackAppStartupProperties(false);
            
            appDependencies.installRecordToRootViewControllerIntoWindow(window!)
            
            //            Test other views on root
            //            appDependencies.installIntroToRootViewControllerIntoWindow(window!)
            //            appDependencies.installSettingsToRootViewControllerIntoWindow(window!)
            //            appDependencies.installShareToRootViewControllerIntoWindow(window!)
            //            appDependencies.installEditorRoomToRootViewControllerIntoWindow(window!)
            //            appDependencies.installDuplicateRoomToRootViewControllerIntoWindow(window!)
            //            appDependencies.installSplitRoomToRootViewControllerIntoWindow(window!)
        } else {
            // other version
            defaults.setObject(currentAppVersion, forKey: "appVersion")
            defaults.synchronize()
            
            Utils().debugLog("setupStartApp Update to \(currentAppVersion)")
            initState = "upgrade"
            
            trackUserProfile();
            trackAppStartupProperties(false);
            appDependencies.installRecordToRootViewControllerIntoWindow(window!)
        }
    }
    
    func configureQualityOnFirstIteration(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(Utils().getStringByKeyFromSettings("high_quality_name"), forKey: SettingsConstants().SETTINGS_QUALITY)
    }
    
    //MARK: - Mixpanel
    
    func sendStartupAppTracking() {
        let initAppProperties = [AnalyticsConstants().TYPE:AnalyticsConstants().TYPE_ORGANIC,
                                 AnalyticsConstants().INIT_STATE:initState,
                                 //                                 AnalyticsConstants().DOUBLE_HOUR_AND_MINUTES: Utils().getDoubleHourAndMinutes()]
        ]
        mixpanel?.track(AnalyticsConstants().APP_STARTED, properties: initAppProperties as [NSObject : AnyObject])
    }
    
    func trackAppStartupProperties(state:Bool) {
        Utils().debugLog("trackAppStartupProperties")
        mixpanel!.identify(Utils().udid)
        
        var appUseCount:Int
        let properties = mixpanel!.currentSuperProperties()
        if let count = properties[AnalyticsConstants().APP_USE_COUNT]{
            appUseCount = count as! Int
        }else{
            appUseCount = 0
        }
        appUseCount += 1
        
        Utils().debugLog("App USE COUNT \(appUseCount)")
        
        let appStartupSuperProperties = [AnalyticsConstants().APP_USE_COUNT:NSNumber.init(int: Int32(appUseCount)),
                                         AnalyticsConstants().FIRST_TIME:state,
                                         AnalyticsConstants().APP: AnalyticsConstants().APP_NAME]
        mixpanel?.registerSuperProperties(appStartupSuperProperties as [NSObject : AnyObject])
    }
    
    func trackUserProfile() {
        Utils().debugLog("The user id is = \(Utils().udid)")
        
        mixpanel!.identify(Utils().udid)
        let userProfileProperties = [AnalyticsConstants().CREATED:Utils().giveMeTimeNow()]
        mixpanel?.people.setOnce(userProfileProperties)
    }
    
    func trackUserProfileGeneralTraits() {
        mixpanel!.identify(Utils().udid)
        
        Utils().debugLog("trackUserProfileGeneralTraits")
        
        let increment:NSNumber = NSNumber.init(integer: 1)
        Utils().debugLog("App USE COUNT Increment by: \(increment)")
        
        mixpanel?.people.increment(AnalyticsConstants().APP_USE_COUNT,by: increment)
        
        let locale = NSLocale.preferredLanguages()[0]
        
        //        let lang = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)
        let langISO = NSLocale.currentLocale().ISO639_2LanguageCode()
        let userProfileProperties = [AnalyticsConstants().TYPE:AnalyticsConstants().USER_TYPE_FREE,
                                     AnalyticsConstants().LOCALE:locale,
                                     AnalyticsConstants().LANG: langISO!] as [NSObject : AnyObject]
        
        mixpanel?.people.set(userProfileProperties)
    }
    
    func trackCreatedSuperProperty() {
        let createdSuperProperty = [AnalyticsConstants().CREATED: Utils().giveMeTimeNow()]
        mixpanel?.registerSuperPropertiesOnce(createdSuperProperty)
    }
    
}

