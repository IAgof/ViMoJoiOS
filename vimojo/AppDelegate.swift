//
//  AppDelegate.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 5/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import Mixpanel
import GoogleSignIn
import AVFoundation
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,GIDSignInDelegate{

    var window: UIWindow?
    let appDependencies = AppDependencies()
    var initState = "firstTime"
    var mixpanel:Mixpanel?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //MIXPANEL
        mixpanel = Mixpanel.sharedInstanceWithToken(AnalyticsConstants().MIXPANEL_TOKEN)
        
        self.configureGoogleSignIn()
        
        // Optional: configure GAI options.
//        let gai = GAI.sharedInstance()
//        gai.trackUncaughtExceptions = true  // report uncaught exceptions
//        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
//        
        //CRASHLYTICS
        Fabric.with([Crashlytics.self])
        
        self.setupStartApp()
        
        return true
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
       return UIInterfaceOrientationMask.All
    }
    
    func configureGoogleSignIn() {
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
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

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    //MARK: - Google Sign In
    func application(application: UIApplication,
                     openURL url: NSURL,
                             options: [String: AnyObject]) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL,
                             sourceApplication: String?,
                             annotation: AnyObject) -> Bool {
        
        print("sourceApp\(sourceApplication)")
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            Utils().debugLog("userID: \(userId) \n idToken: \(idToken) \n fullName: \(fullName) \n givenName: \(givenName) \n familyName: \(familyName) \n email: \(email) \n")
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
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
            
//            appDependencies.installRecordToRootViewControllerIntoWindow(window!)
            
            //            Test other views on root
            //            appDependencies.installIntroToRootViewControllerIntoWindow(window!)
            appDependencies.installSettingsToRootViewControllerIntoWindow(window!)
            //            appDependencies.installShareToRootViewControllerIntoWindow(window!)
//                        appDependencies.installEditorRoomToRootViewControllerIntoWindow(window!)
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
        
        defaults.setObject(Utils().getStringByKeyFromSettings(AVCaptureSessionPreset1920x1080), forKey: SettingsConstants().SETTINGS_RESOLUTION)
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

