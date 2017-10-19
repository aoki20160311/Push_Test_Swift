//
//  AppDelegate.swift
//  Push_Test_Swift
//
//  Created by user on 2017/10/18.
//  Copyright © 2017年 user. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var successful:Bool? = false
        //var successfulETPush:Bool? = false
        let kETAccessToken_Debug = "hqh6g53zdqb2f92uzvrkc9sc"
        let kETAppID_Debug = "234879b1-7f9d-4ccd-bc03-633d36253d7c"
        
        
        // Set to YES to enable logging while debugging
        //let ETPushobj = ETPush.setETLoggerToRequiredState(true)
        //successfulETPush = ETPush.setETLoggerToRequiredState(true)
        _ = ETPush.setETLoggerToRequiredState(true)
        
        //USING DEBUG KEYS
        // configure and set initial settings of the JB4ASDK
        do{
            
            try  successful = ((ETPush.pushManager()?.configureSDK(withAppID: kETAppID_Debug, andAccessToken: kETAccessToken_Debug,
                                                                   withAnalytics: true, andLocationServices: true, andProximityServices: true, andCloudPages: true, withPIAnalytics:true)) != nil)
            
        }catch{
            print("ERROR")
        }
        
        if successful != nil{
            if successful == false{
                DispatchQueue.main.async(execute: {() -> Void in
                    // something failed in the configureSDKWithAppID call - show what the error is
                    
                    let alert = UIAlertController(title: "Failed configureSDKWithAppID!", message: "Failed configureSDKWithAppID!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                })
            }else{
                
                //let settings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], Categories: nil)
                let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                
                
                ETPush.pushManager()?.register(settings)
                ETPush.pushManager()?.registerForRemoteNotifications()
                
                // inform the JB4ASDK of the launch options - possibly UIApplicationLaunchOptionsRemoteNotificationKey or UIApplicationLaunchOptionsLocalNotificationKey
                ETPush.pushManager()?.applicationLaunched(options: launchOptions)
                
                // This method is required in order for location messaging to work and the user's location to be processed
                ETLocationManager.sharedInstance().startWatchingLocation()
            }
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    /// リモート通知のデバイストークン取得
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //self.popinfoReceiver?.registerToken(deviceToken)
        
        // inform the JB4ASDK of the device token
        ETPush.pushManager()?.registerDeviceToken(deviceToken)
    }

    /// リモート通知登録失敗
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // inform the JB4ASDK that the device failed to register and did not receive a device token
        ETPush.pushManager()?.applicationDidFailToRegisterForRemoteNotificationsWithError(error)
        
    }
    
    /// リモート通知受診
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        #if DEBUG
            print("popinfo payload 2:", userInfo)
        #endif
        
        if UIApplication.shared.applicationState == .active {
            #if DEBUG
                print("popinfo no action. application is active")
            #endif
        } else {
            
            // inform the JB4ASDK that the device received a remote notification
            ETPush.pushManager()?.handleNotification(userInfo, for:application.applicationState);
        }
    
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

