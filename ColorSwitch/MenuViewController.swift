//
//  MenuViewController.swift
//  ColorSwitch
//
//  Created by Zachary Elia on 10/23/17.
//  Copyright © 2017 Zachary Elia. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit

class MenuViewController: UIViewController {
    @IBOutlet var startButton: UIButton!
    @IBOutlet var modeButton: UIButton!
    @IBOutlet var rateButton: UIButton!
    @IBOutlet var gamecenterButton: UIButton!
    @IBOutlet var soundButton: UIButton!
    
    @IBOutlet var buttonsView: UIView!
    
    var mode = "Easy"
    var shouldPlaySound: Bool!

    var gcEnabled: Bool!
    var gcDefaultLeaderboard: String!
    let leaderboardID = "ColorSwitchLeaderboard"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = Color.primaryColor
        
        buttonsView.backgroundColor = .clear
        
        for button in [startButton, modeButton, rateButton, gamecenterButton, soundButton] {
            button?.backgroundColor = Color.secondaryColor
            button?.layer.cornerRadius = UI.cornerRadius
        }
        
        mode = UserDefaults.standard.string(forKey: "mode")!
        modeButton.setTitle(mode.uppercased(), for: .normal)

        if UserDefaults.standard.bool(forKey: "sound") {
            shouldPlaySound = true
            soundButton.setBackgroundImage(UIImage(named: "sound"), for: .normal)
        }
        else {
            shouldPlaySound = false
            soundButton.setBackgroundImage(UIImage(named: "mute"), for: .normal)
        }

        authenticateLocalPlayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true

                UserDefaults.standard.set(true, forKey: "leaderboardChecked")

                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        self.gcDefaultLeaderboard = leaderboardIdentifer!

                    }
                })

            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!.localizedDescription)
            }
        }
    }
        
    @IBAction func tappedStart(_ sender: Any) {
        UIBuilder.play(sound: "tap")
    }
    
    @IBAction func tappedMode(_ sender: Any) {
        UIBuilder.play(sound: "tap")
        UIBuilder.changeMode(currentButton: modeButton, currentView: view, buttonsView: buttonsView)
    }
    
    @IBAction func tappedRate(_ sender: Any) {
        UIBuilder.play(sound: "tap")
        UIBuilder.animatePop(animatedView: rateButton, closure: {
            UIApplication.shared.openURL(URL(string: Config.URL)!)
        })
    }
    
    @IBAction func tappedGamecenter(_ sender: Any) {
        UIBuilder.play(sound: "tap")
        UIBuilder.animatePop(animatedView: gamecenterButton, closure: {
            let gcVC = GKGameCenterViewController()
            gcVC.gameCenterDelegate = self
            gcVC.viewState = .leaderboards
            gcVC.leaderboardIdentifier = self.leaderboardID
            self.present(gcVC, animated: true, completion: nil)
        })
    }
    
    @IBAction func tappedSound(_ sender: Any) {
        UIBuilder.changeSound(soundButton: soundButton, currentView: view, closure: {
            self.shouldPlaySound = UserDefaults.standard.bool(forKey: "sound")
        })
        UIBuilder.play(sound: "tap")
        UIBuilder.animatePop(animatedView: soundButton, closure: {
            // TODO: Implement muting/unmuting
        })
    }
    
}

extension MenuViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
