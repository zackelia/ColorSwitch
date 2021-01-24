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
    
    @IBOutlet var lossLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var highScoreLabel: UILabel!
    @IBOutlet var modeLabel: UILabel!
    
    @IBOutlet var playAgainButton: UIButton!
    @IBOutlet var modeButton: UIButton!
    @IBOutlet var menuButton: UIButton!

    @IBOutlet var buttonsView: UIStackView!

    var game: Game!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lossLabel.text = game.lossMessage.uppercased()
        scoreLabel.text = "\(game.score)".uppercased()
        highScoreLabel.text = "Best: \(game.high!)".uppercased()
        modeLabel.text = "\(game.mode!)".uppercased()
        
        for button in [playAgainButton, modeButton, menuButton] {
            button?.backgroundColor = Color.secondaryColor
            button?.layer.cornerRadius = UI.cornerRadius
            button?.startAnimatingPressActions()
        }
        
        setupMode()
        
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

    func setupMode() {
        modeButton.titleLabel?.lineBreakMode = .byWordWrapping

        game.mode = UserDefaults.standard.string(forKey: "mode")!

        var subtitle: String
        if game.mode == "Easy" {
            subtitle = "Classic gameplay"
        } else if game.mode == "Hard" {
            subtitle = "Faster gameplay with a twist"
        } else if game.mode == "Insane" {
            subtitle = "More colors, less time"
        } else {
            subtitle = "30 second games"
        }

        let title = UIBuilder.subtitledString(title: game.mode, subtitle: subtitle, sizeClass: self.traitCollection.horizontalSizeClass)

        //assigning the resultant attributed strings to the button
        modeButton?.setAttributedTitle(title, for: .normal)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedPlayAgain(_ sender: Any) {
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
    
    @IBAction func tappedMenu(_ sender: Any) {
        UIBuilder.play(sound: "tap")
    }
}

