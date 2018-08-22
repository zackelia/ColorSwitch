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

    static func changeMode(currentButton: UIButton, currentView: UIView, buttonsView: UIView){
        let tempButton = UIButton(frame: currentButton.frame)
        tempButton.backgroundColor = Color.secondaryColor
        tempButton.layer.cornerRadius = UI.cornerRadius
        
        let currentMode = currentButton.currentTitle!
        var newMode: String

        if currentMode == "Easy".uppercased() {
            newMode = "Hard"
        }
        else if currentMode == "Hard".uppercased() {
            newMode = "Trial"
        }
        else {
            newMode = "Easy"
        }
        
        UserDefaults.standard.set(newMode, forKey: "mode")
        
        let attributes = [ NSAttributedString.Key.font: UIFont(name: "Futura", size: 30.0)!,
                           NSAttributedString.Key.foregroundColor: UIColor.white ]
        let attributedString = NSAttributedString(string: currentMode.uppercased(), attributes: attributes)
        tempButton.setAttributedTitle(attributedString, for: UIControl.State.normal)
        currentButton.setTitle(newMode.uppercased(), for: UIControl.State.normal)
        
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

