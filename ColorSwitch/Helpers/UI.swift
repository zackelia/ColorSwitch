//
//  UIBuilder.swift
//  ColorSwitch
//
//  Created by Zachary Elia on 10/24/17.
//  Copyright © 2017 Zachary Elia. All rights reserved.
//

import UIKit
import AVFoundation

struct UIBuilder {
    private static var player: AVAudioPlayer?

    static func play(sound: String) {
        if !UserDefaults.standard.bool(forKey: "sound") {
            return
        }
        if let asset = NSDataAsset(name: sound) {
            do {
                player = try AVAudioPlayer(data: asset.data, fileTypeHint: "wav")
                player?.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    static func animatePop(animatedView: UIView, closure: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25, animations: {
            animatedView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { finished in
            UIView.animate(withDuration: 0.25, animations: {
                animatedView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { finish in
                closure()
            })
        })
    }

    static func subtitledString(title: String, subtitle: String, sizeClass: UIUserInterfaceSizeClass) -> NSMutableAttributedString {
        let text = title.uppercased() + "\n" + subtitle.uppercased() as NSString

        let newlineRange: NSRange = text.range(of: "\n")

        //getting both substrings
        var substring1 = ""
        var substring2 = ""

        if(newlineRange.location != NSNotFound) {
            substring1 = text.substring(to: newlineRange.location)
            substring2 = text.substring(from: newlineRange.location)
        }

        var size: CGFloat = 30.0
        if sizeClass == UIUserInterfaceSizeClass.regular {
            size = 50.0
        }

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        //assigning diffrent fonts to both substrings
        let font1: UIFont = UIFont(name: "Futura", size: size)!
        let attributes1 = [NSMutableAttributedString.Key.font: font1, .paragraphStyle: paragraph, .foregroundColor: UIColor.white]
        let attrString1 = NSMutableAttributedString(string: substring1, attributes: attributes1)

        let font2: UIFont = UIFont(name: "Futura", size: size / 2)!
        let attributes2 = [NSMutableAttributedString.Key.font: font2, .paragraphStyle: paragraph, .foregroundColor: UIColor.white]
        let attrString2 = NSMutableAttributedString(string: substring2, attributes: attributes2)

        //appending both attributed strings
        attrString1.append(attrString2)

        return attrString1
    }

    static func changeMode(slideLeft: Bool, currentButton: UIButton, currentView: UIView, buttonsView: UIStackView, sizeClass: UIUserInterfaceSizeClass){
        let tempButton = UIButton(frame: currentButton.frame)
        tempButton.backgroundColor = Color.secondaryColor
        tempButton.layer.cornerRadius = UI.cornerRadius
        tempButton.titleLabel?.lineBreakMode = .byWordWrapping

        
        let currentMode = currentButton.currentAttributedTitle!.string
        var newMode: String
        var subtitle: String
        var oldMode: String
        var oldSubtitle: String

        if slideLeft {
            if currentMode.contains("EASY") {
                newMode = "Hard"
                subtitle = "Faster gameplay with a twist"
                oldMode = "Easy"
                oldSubtitle = "Classic gameplay"
            }
            else if currentMode.contains("HARD") {
                newMode = "Insane"
                subtitle = "More colors, less time"
                oldMode = "Hard"
                oldSubtitle = "Faster gameplay with a twist"
            }
            else if currentMode.contains("INSANE") {
                newMode = "Trial"
                subtitle = "30 second games"
                oldMode = "Insane"
                oldSubtitle = "More colors, less time"
            }
            else {
                newMode = "Easy"
                subtitle = "Classic gameplay"
                oldMode = "Trial"
                oldSubtitle = "30 second games"
            }
        } else {
            if currentMode.contains("EASY") {
                newMode = "Trial"
                subtitle = "30 second games"
                oldMode = "Easy"
                oldSubtitle = "Classic gameplay"
            }
            else if currentMode.contains("HARD") {
                newMode = "Easy"
                subtitle = "Classic gameplay"
                oldMode = "Hard"
                oldSubtitle = "Faster gameplay with a twist"
            }
            else if currentMode.contains("INSANE") {
                newMode = "Hard"
                subtitle = "Faster gameplay with a twist"
                oldMode = "Insane"
                oldSubtitle = "More colors, less time"
            }
            else {
                newMode = "Insane"
                subtitle = "More colors, less time"
                oldMode = "Trial"
                oldSubtitle = "30 second games"
            }
        }

        UserDefaults.standard.set(newMode, forKey: "mode")

        let tempString = subtitledString(title: oldMode, subtitle: oldSubtitle, sizeClass: sizeClass)
        let currentString = subtitledString(title: newMode, subtitle: subtitle, sizeClass: sizeClass)
//
//        let attributes = [ NSAttributedString.Key.font: UIFont(name: "Futura", size: size)!,
//                           NSAttributedString.Key.foregroundColor: UIColor.white ]

//        let attributedString = NSAttributedString(string: currentMode.uppercased(), attributes: attributes)
        tempButton.setAttributedTitle(tempString, for: .normal)
        currentButton.setAttributedTitle(currentString, for: .normal)
//        currentButton.setTitle(newMode.uppercased(), for: UIControl.State.normal)

        if slideLeft {
            tempButton.frame.origin.x = currentButton.frame.origin.x + buttonsView.frame.origin.x
            tempButton.frame.origin.y = currentButton.frame.origin.y + buttonsView.frame.origin.y
            currentView.addSubview(tempButton)
            currentButton.center.x += currentView.bounds.width

            UIView.animate(withDuration: 0.45, animations: {
                tempButton.center.x -= currentView.bounds.width
            }, completion: { finished in
                tempButton.removeFromSuperview()
            })

            UIView.animate(withDuration: 0.45, animations: {
                currentButton.center.x -= currentView.bounds.width
            }, completion: { finished in

            })
        } else {
            tempButton.frame.origin.x = currentButton.frame.origin.x + buttonsView.frame.origin.x
            tempButton.frame.origin.y = currentButton.frame.origin.y + buttonsView.frame.origin.y
            currentView.addSubview(tempButton)
            currentButton.center.x -= currentView.bounds.width

            UIView.animate(withDuration: 0.45, animations: {
                tempButton.center.x += currentView.bounds.width
            }, completion: { finished in
                tempButton.removeFromSuperview()
            })

            UIView.animate(withDuration: 0.45, animations: {
                currentButton.center.x += currentView.bounds.width
            }, completion: { finished in

            })
        }
    }
    
    // TODO: Fix this, it doesn't animate
    static func changeSound(soundButton: UIButton, currentView: UIView, closure: @escaping () -> Void) {
        UIView.animate(withDuration: 0.75) {
            let sound = UserDefaults.standard.bool(forKey: "sound")
            let name = sound ? "mute" : "sound"
            soundButton.setBackgroundImage(UIImage(named: name), for: UIControl.State.normal)
            UserDefaults.standard.set(!sound, forKey: "sound")
            closure()
        }
    }
    
}

