//
//  GameViewController.swift
//  ColorSwitch
//
//  Created by Zachary Elia on 10/23/17.
//  Copyright © 2017 Zachary Elia. All rights reserved.
//

import UIKit
import GameKit

class GameViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!

    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var highScoreLabel: UILabel!

    var timer: Timer!
    var shouldPlaySound = UserDefaults.standard.bool(forKey: "sound")

    var game: Game!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        button1.backgroundColor = Color.red
        button2.backgroundColor = Color.blue
        button3.backgroundColor = Color.green
        button4.backgroundColor = Color.yellow

        for button in [button1, button2, button3, button4] {
            button?.layer.cornerRadius = UI.cornerRadius
        }

        let mode = UserDefaults.standard.string(forKey: "mode")!
        game = Game(mode: mode)

        timer = Timer.scheduledTimer(timeInterval: game.timerLength, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: false);
        timer.invalidate()

        updateUI()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tappedButton(button: UIButton) {
        if game.didSelectCorrect(chose: button.backgroundColor!, correct: colorLabel.text!) {
            UIBuilder.play(sound: "correct")
            game.score += 1

            if game.score > game.high {
                game.high = game.score
                UserDefaults.standard.set(game.high, forKey: game.mode.lowercased() + "HighScore")
            }

            if game.mode == "Hard" {
                swapRandomButtons()
            }

            if game.mode != "Trial" || (game.mode == "Trial" && game.score == 1) {
                resetTimer()
            }

            updateUI()
        }
        else {
            UIBuilder.play(sound: "wrong")
            timer.invalidate()
            game.lossMessage  = "Wrong color!"
            performSegue(withIdentifier: "lose", sender: nil)
        }
    }

    func updateUI() {
        colorLabel.text = game.getNewWord()
        colorLabel.textColor = game.getNewColor()
        scoreLabel.text = "Score: \(game.score)".uppercased()
        highScoreLabel.text = "\(game.mode!) High Score: \(game.high!)".uppercased()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LoseViewController {
            let vc = segue.destination as? LoseViewController
            vc?.game = game
        }
    }

    func swapRandomButtons() {
        var buttons = [button1, button2, button3, button4]
        let swaps = Int(arc4random_uniform(3) + 1)
        for _ in 0...swaps - 1 {
            let rand1 = Int(arc4random_uniform(4))
            let rand2 = Int(arc4random_uniform(4))

            let temp = buttons[rand1]?.backgroundColor
            buttons[rand1]?.backgroundColor = buttons[rand2]?.backgroundColor
            buttons[rand2]?.backgroundColor = temp
        }
    }

    func resetTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: game.timerLength, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: false);
    }
    
    @objc func timerUpdate() {
        UIBuilder.play(sound: "wrong")
        game.lossMessage = "You ran out of time!"
        performSegue(withIdentifier: "lose", sender: nil)
    }

    @IBAction func button1Tapped(_ sender: Any) {
        tappedButton(button: button1)
    }
    
    @IBAction func button2Tapped(_ sender: Any) {
        tappedButton(button: button2)
    }
    
    @IBAction func button3Tapped(_ sender: Any) {
        tappedButton(button: button3)
    }
    
    @IBAction func button4Tapped(_ sender: Any) {
        tappedButton(button: button4)
    }
}

