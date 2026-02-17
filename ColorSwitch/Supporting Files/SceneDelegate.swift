//
//  SceneDelegate.swift
//  ColorSwitch
//
//  Created by Zack on 2/16/26.
//  Copyright © 2026 Zachary Elia. All rights reserved.
//

import AdSupport
import AppTrackingTransparency
import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // Confirm the scene is a window scene in iOS or iPadOS.
        guard let _ = scene as? UIWindowScene else { return }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
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
    }

    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
}

