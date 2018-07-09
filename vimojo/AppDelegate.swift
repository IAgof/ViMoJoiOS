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
import Auth0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var appDependencies: AppDependencies!
    var initState = "firstTime"
    var mixpanel: Mixpanel?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AudioSettings.loadValues()
        VideoSettings.loadValues()
        LoginState.loadState()
        RealmMigrationsUseCase.updateMigrationDefault()
        appDependencies = AppDependencies()
        CustomDPTheme().configureTheme()
        //MIXPANEL
        mixpanel = Mixpanel.sharedInstance(withToken: AnalyticsConstants().MIXPANEL_TOKEN)
        mixpanel?.enableLogging = false

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

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
       return UIInterfaceOrientationMask.all
    }

    func configureGoogleSignIn() {
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "937422921949-2m6qvrnqrn0g0hps204voiacrflkjg57.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
    }

    // MARK: - Google Sign In
    func application(_ application: UIApplication,
                     open url: URL,
                             options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {

        return Auth0.resumeAuth(url, options: options)
//        return GIDSignIn.sharedInstance().handle(url,
//                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
//                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }

    func application(_ application: UIApplication,
                     open url: URL,
                             sourceApplication: String?,
                             annotation: Any) -> Bool {

        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                withError error: Error!) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    // MARK: - Inner functions
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

            ViMoJoTracker.sharedInstance.trackUserProfile()
            ViMoJoTracker.sharedInstance.trackCreatedSuperProperty()
            ViMoJoTracker.sharedInstance.trackAppStartupProperties(true)
        } else if previousVersion == currentAppVersion {
            // same version
            Utils().debugLog("setupStartApp Same version")
            initState = "returning"

            ViMoJoTracker.sharedInstance.trackAppStartupProperties(false)
        } else {
            // other version
            defaults.set(currentAppVersion, forKey: "appVersion")
            defaults.synchronize()

            Utils().debugLog("setupStartApp Update to \(currentAppVersion)")
            initState = "upgrade"

            ViMoJoTracker.sharedInstance.trackUserProfile()
            ViMoJoTracker.sharedInstance.trackAppStartupProperties(false)
        }
        
        let controller = PermissionsRouter.createModule(recordWireFrame: appDependencies.recordWireframe,
                                                        drawerWireframe: appDependencies.recordDrawerWireframe,
                                                        window: window!)
        window!.rootViewController = UINavigationController(rootViewController: controller)

        ViMoJoTracker.sharedInstance.sendStartupAppTracking(initState: initState)
    }
    
}
