//
//  AppDelegate.swift
//  ColorSwitch
//
//  Created by Zachary Elia on 10/22/17.
//  Copyright © 2017 Zachary Elia. All rights reserved.
//

import UIKit
import AVFoundation
import UnityAds
import AppTrackingTransparency
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool {
        // Override point for customization after application launch.
        UnityAds.initialize(UnityKeys.appID)//, testMode: true)

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.ambient)), mode: AVAudioSession.Mode.default)

            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                        case .authorized:
                            // Tracking authorization dialog was shown
                            // and we are authorized
                            print("Authorized")
                            // Now that we are authorized we can get the IDFA
                            print(ASIdentifierManager.shared().advertisingIdentifier)
                        case .denied:
                            // Tracking authorization dialog was
                            // shown and permission is denied
                            print("Denied")
                        case .notDetermined:
                            // Tracking authorization dialog has not been shown
                            print("Not Determined")
                        case .restricted:
                            print("Restricted")
                        @unknown default:
                            print("Unknown")
                    }
                }
            }
            else if ATTrackingManager.trackingAuthorizationStatus == .authorized
            {
                print("Advertising identifier: \(ASIdentifierManager.shared().advertisingIdentifier)")
            }
            else {
                print("Authorization status: \(ATTrackingManager.trackingAuthorizationStatus.rawValue)")
            }
        } else {
            // Fallback on earlier versions
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
