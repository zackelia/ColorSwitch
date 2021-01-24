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
    
    @IBOutlet var buttonsView: UIStackView!

    var mode = "Easy"
    var shouldPlaySound: Bool!

    var gcEnabled: Bool!
    var gcDefaultLeaderboard: String!
    let leaderboardID = "ColorSwitchLeaderboard"

    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for button in [startButton, modeButton, rateButton, gamecenterButton, soundButton] {
            button?.backgroundColor = Color.secondaryColor
            button?.layer.cornerRadius = UI.cornerRadius
            button?.startAnimatingPressActions()
        }

        if UserDefaults.standard.string(forKey: "mode") == nil {
            UserDefaults.standard.set(mode, forKey: "mode")
        }

        if UserDefaults.standard.bool(forKey: "sound") {
            shouldPlaySound = true
            soundButton.setBackgroundImage(UIImage(named: "sound"), for: UIControl.State.normal)
        }
        else {
            shouldPlaySound = false
            soundButton.setBackgroundImage(UIImage(named: "mute"), for: UIControl.State.normal)
        }

        Chartboost.setMuted(!shouldPlaySound)

        setupMode()

        authenticateLocalPlayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupMode() {
        modeButton.titleLabel?.lineBreakMode = .byWordWrapping

        mode = UserDefaults.standard.string(forKey: "mode")!

        var subtitle: String
        if mode == "Easy" {
            subtitle = "Classic gameplay"
        } else if mode == "Hard" {
            subtitle = "Faster gameplay with a twist"
        } else if mode == "Insane" {
            subtitle = "More colors, less time"
        } else {
            subtitle = "30 second games"
        }

        let title = UIBuilder.subtitledString(title: mode, subtitle: subtitle, sizeClass: self.traitCollection.horizontalSizeClass)

        //assigning the resultant attributed strings to the button
        modeButton?.setAttributedTitle(title, for: .normal)

    }

    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

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
    
    @IBAction func tappedMode(_ sender: UIButton!, event:UIEvent!) {
        UIBuilder.play(sound: "tap")
        let currentTouch: CGPoint = (event.allTouches?.first?.location(in: sender))!
        var slideLeft = true
        if currentTouch.x < modeButton.frame.width / 2 {
            slideLeft = false
        }
        UIBuilder.changeMode(slideLeft: slideLeft, currentButton: modeButton, currentView: view, buttonsView: buttonsView, sizeClass: self.traitCollection.horizontalSizeClass)
    }
    
    @IBAction func tappedRate(_ sender: Any) {
        UIBuilder.play(sound: "tap")
        UIApplication.shared.open(URL(string: Config.URL)!, options: [:], completionHandler: nil)
    }

    @IBAction func tappedGamecenter(_ sender: Any) {
        UIBuilder.play(sound: "tap")
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .dashboard
        self.present(gcVC, animated: true, completion: nil)
    }

    @IBAction func tappedSound(_ sender: Any) {
        UIBuilder.changeSound(soundButton: soundButton, currentView: view, closure: {
            self.shouldPlaySound = UserDefaults.standard.bool(forKey: "sound")
        })
        UIBuilder.play(sound: "tap")
    }
    
}



