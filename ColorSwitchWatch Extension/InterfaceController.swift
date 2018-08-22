//
//  InterfaceController.swift
//  ColorSwitchWatch Extension
//
//  Created by Zack on 8/22/18.
//  Copyright © 2018 Zachary Elia. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    let colors = ["Red": Color.red, "Blue": Color.blue, "Green": Color.green, "Yellow": Color.yellow]

    var name: String!
    var color: UIColor!
    var score = 0

    @IBOutlet var wordLabel: WKInterfaceLabel!
    @IBOutlet var scoreLabel: WKInterfaceLabel!

    @IBOutlet var redButton: WKInterfaceButton!
    @IBOutlet var blueButton: WKInterfaceButton!
    @IBOutlet var greenButton: WKInterfaceButton!
    @IBOutlet var yellowButton: WKInterfaceButton!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
        setRandomColor()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        redButton.setBackgroundColor(Color.red)
        blueButton.setBackgroundColor(Color.blue)
        greenButton.setBackgroundColor(Color.green)
        yellowButton.setBackgroundColor(Color.yellow)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func setRandomColor() {
        name = Array(colors.keys)[Int(arc4random_uniform(4))]
        color = Array(colors.values)[Int(arc4random_uniform(4))]

        wordLabel.setText(name)
        wordLabel.setTextColor(color)
    }

    func tappedButton(tapped: String) {
        if tapped == name {
            score += 1
            scoreLabel.setText("Score: \(score)".uppercased())
            setRandomColor()
        }
        else {
            let playAgain = WKAlertAction(title: "Play Again", style: .default) {
                self.score = 0
                self.scoreLabel.setText("Score: 0".uppercased())
            }

            self.presentAlert(withTitle: "You picked the wrong color!", message: "Your score was \(score)!", preferredStyle: .alert, actions: [playAgain])
        }
    }

    @IBAction func tappedRed() {
        tappedButton(tapped: "Red")
    }

    @IBAction func tappedBlue() {
        tappedButton(tapped: "Blue")
    }

    @IBAction func tappedGreen() {
        tappedButton(tapped: "Green")
    }

    @IBAction func tappedYellow() {
        tappedButton(tapped: "Yellow")
    }

}

