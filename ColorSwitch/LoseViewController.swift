//
//  LoseViewController.swift
//  ColorSwitch
//
//  Created by Zachary Elia on 10/28/17.
//  Copyright © 2017 Zachary Elia. All rights reserved.
//

import UIKit
import StoreKit

class LoseViewController: UIViewController {
    
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var lossLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var highScoreLabel: UILabel!
    
    @IBOutlet var playAgainButton: UIButton!
    @IBOutlet var modeButton: UIButton!
    @IBOutlet var menuButton: UIButton!

    var game: Game!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = Color.primaryColor
        
        buttonsView.backgroundColor = .clear
        
        lossLabel.text = game.lossMessage
        scoreLabel.text = "Score: \(game.score)".uppercased()
        highScoreLabel.text = "\(game.mode!) High Score: \(game.high!)".uppercased()
        
        for button in [playAgainButton, modeButton, menuButton] {
            button?.backgroundColor = Color.secondaryColor
            button?.layer.cornerRadius = UI.cornerRadius
        }
        
        let mode = UserDefaults.standard.string(forKey: "mode")!
        modeButton.setTitle(mode.uppercased(), for: UIControl.State.normal)

        let gamesPlayed = UserDefaults.standard.integer(forKey: "gamesPlayed") + 1
        UserDefaults.standard.set(gamesPlayed, forKey: "gamesPlayed")

        game.submitHighScore()
        game.submitAchievements()

        if gamesPlayed % 4 == 0 && gamesPlayed != 0 {
            if Chartboost.hasInterstitial(CBLocationHomeScreen) {
                Chartboost.showInterstitial(CBLocationHomeScreen)
            }
            else {
                Chartboost.cacheInterstitial(CBLocationHomeScreen)
            }
        }
        else if gamesPlayed > 16 && gamesPlayed % 16 == 1 {
            SKStoreReviewController.requestReview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedPlayAgain(_ sender: Any) {
        UIBuilder.play(sound: "tap")
    }
    
    @IBAction func tappedMode(_ sender: Any) {
        UIBuilder.play(sound: "tap")
        UIBuilder.changeMode(currentButton: modeButton, currentView: view, buttonsView: buttonsView, sizeClass: self.traitCollection.horizontalSizeClass)
    }
    
    @IBAction func tappedMenu(_ sender: Any) {
        UIBuilder.play(sound: "tap")
    }
}

