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
import VideonaProject
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,GIDSignInDelegate{

    var window: UIWindow?
    let appDependencies = AppDependencies()
    var initState = "firstTime"
    var mixpanel:Mixpanel?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //MIXPANEL
        #if DEBUG
        
        #else
            mixpanel = Mixpanel.sharedInstance(withToken: AnalyticsConstants().MIXPANEL_TOKEN)
        #endif
                
        self.configureGoogleSignIn()
        
        // Optional: configure GAI options.
//        let gai = GAI.sharedInstance()
//        gai.trackUncaughtExceptions = true  // report uncaught exceptions
//        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
//        
        //CRASHLYTICS
        Fabric.with([Crashlytics.self])
        
        self.setupStartApp()
        
        CheckMicPermissionUseCase().askIfNeeded()
        CheckPhotoRollPermissionUseCase().askIfNeeded()
        CheckCameraPermissionUseCase().askIfNeeded()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
       return UIInterfaceOrientationMask.all
    }
    
    func configureGoogleSignIn() {
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
    }
    
    //MARK: - Google Sign In
    func application(_ application: UIApplication,
                     open url: URL,
                             options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                             sourceApplication: String?,
                             annotation: Any) -> Bool {
        
        print("sourceApp\(sourceApplication)")
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
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
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: Error!){
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    //MARK: - Inner functions
    func setupStartApp() {
        let defaults = UserDefaults.standard
        
        let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let previousVersion = defaults.string(forKey: "appVersion")
        
        if previousVersion == nil {
            // first launch
            defaults.set(currentAppVersion, forKey: "appVersion")
            defaults.synchronize()
            
            Utils().debugLog("setupStartApp First time")
            initState = "firstTime"
            
            trackUserProfile();
            trackCreatedSuperProperty();
            trackAppStartupProperties(true);
                        
            appDependencies.installRecordToRootViewControllerIntoWindow(window!)
        } else if previousVersion == currentAppVersion {
            // same version
            Utils().debugLog("setupStartApp Same version")
            initState = "returning"
            
            trackAppStartupProperties(false);
            
            appDependencies.installRecordToRootViewControllerIntoWindow(window!)
            
        } else {
            // other version
            defaults.set(currentAppVersion, forKey: "appVersion")
            defaults.synchronize()
            
            Utils().debugLog("setupStartApp Update to \(currentAppVersion)")
            initState = "upgrade"
            
            trackUserProfile();
            trackAppStartupProperties(false);
            appDependencies.installRecordToRootViewControllerIntoWindow(window!)
        }
    }
    
    //MARK: - Mixpanel
    
    func sendStartupAppTracking() {
        let initAppProperties = [AnalyticsConstants().TYPE:AnalyticsConstants().TYPE_ORGANIC,
                                 AnalyticsConstants().INIT_STATE:initState,
                                 //                                 AnalyticsConstants().DOUBLE_HOUR_AND_MINUTES: Utils().getDoubleHourAndMinutes()]
        ]
        mixpanel?.track(AnalyticsConstants().APP_STARTED, properties: initAppProperties as [AnyHashable: Any])
    }
    
    func trackAppStartupProperties(_ state:Bool) {
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
        
        let appStartupSuperProperties = [AnalyticsConstants().APP_USE_COUNT:NSNumber.init(value: Int32(appUseCount) as Int32),
                                         AnalyticsConstants().FIRST_TIME:state,
                                         AnalyticsConstants().APP: AnalyticsConstants().APP_NAME] as [String : Any]
        mixpanel?.registerSuperProperties(appStartupSuperProperties as [AnyHashable: Any])
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
        
        let increment:NSNumber = NSNumber.init(value: 1 as Int)
        Utils().debugLog("App USE COUNT Increment by: \(increment)")
        
        mixpanel?.people.increment(AnalyticsConstants().APP_USE_COUNT,by: increment)
        
        let locale = Locale.preferredLanguages[0]
        
        //        let lang = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)
        let langISO = (Locale.current as NSLocale).iso639_2LanguageCode()
        let userProfileProperties = [AnalyticsConstants().TYPE:AnalyticsConstants().USER_TYPE_FREE,
                                     AnalyticsConstants().LOCALE:locale,
                                     AnalyticsConstants().LANG: langISO!] as [AnyHashable: Any]
        
        mixpanel?.people.set(userProfileProperties)
    }
    
    func trackCreatedSuperProperty() {
        let createdSuperProperty = [AnalyticsConstants().CREATED: Utils().giveMeTimeNow()]
        mixpanel?.registerSuperPropertiesOnce(createdSuperProperty)
    }
}

