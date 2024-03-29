//
//  Constants.swift
//  ColorSwitch
//
//  Created by Zachary Elia on 10/22/17.
//  Copyright © 2017 Zachary Elia. All rights reserved.
//

import UIKit

struct Config {
    static let URL = "itms-apps://itunes.apple.com/app/id923653602?mt=8"
}

struct Color {
    static let primaryColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0) // #262626
    static let secondaryColor = UIColor(red:1.00, green:0.60, blue:0.20, alpha:1.0) // #FF9933

    static let red = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0) // #FF3B30
    static let blue = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0) // #007AFF
    static let green = UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0) // #4CD964
    static let yellow = UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0) // ##FFCC00

    static let orange = UIColor(red: 1.00, green: 0.60, blue: 0.20, alpha: 1.00) // #FF9933
    static let pink = UIColor(red: 1.00, green: 0.57, blue: 0.94, alpha: 1.00) // #FF91EF
    static let purple = UIColor(red: 0.71, green: 0.25, blue: 0.89, alpha: 1.00) // #B540E3
    static let white = UIColor.white
}

struct UI {
    static let cornerRadius : CGFloat = 10.0
}

struct Ad {
    static var loaded: Bool = false
}
