//
//  Game.swift
//  ColorSwitch
//
//  Created by Zachary Elia on 10/28/17.
//  Copyright © 2017 Zachary Elia. All rights reserved.
//

import UIKit
import GameKit

class Game {
    private var colors = ["RED": Color.red, "BLUE": Color.blue, "GREEN": Color.green, "YELLOW": Color.yellow]
    var current: [String: UIColor]!

    var score = 0
    var high: Int!
    var mode: String!
    var leaderboardID: String!
    var timerLength: Double!
    var lossMessage: String!

    init(mode: String) {
        self.mode = mode
        high = UserDefaults.standard.integer(forKey: mode.lowercased() + "HighScore")
        setMode()
    }

    func setMode() {
        current = colors
        switch mode {
        case "Easy":
            timerLength = 2.0
            leaderboardID = "ColorSwitchLeaderboard"
            colors = ["RED": Color.red, "BLUE": Color.blue, "GREEN": Color.green, "YELLOW": Color.yellow]
        case "Hard":
            timerLength = 1.0
            leaderboardID = "ColorSwitchLeaderboard1"
            colors = ["RED": Color.red, "BLUE": Color.blue, "GREEN": Color.green, "YELLOW": Color.yellow]
        case "Trial":
            timerLength = 30.0
            leaderboardID = "ColorSwitchLeaderboard2"
            colors = ["RED": Color.red, "BLUE": Color.blue, "GREEN": Color.green, "YELLOW": Color.yellow]
        case "Insane":
            timerLength = 0.8
            leaderboardID = "ColorSwitchLeaderboard3"
            colors = ["RED": Color.red, "BLUE": Color.blue, "GREEN": Color.green, "YELLOW": Color.yellow,
                      "ORANGE": Color.orange, "PINK": Color.pink, "PURPLE": Color.purple, "WHITE": Color.white]
            current = Dictionary(uniqueKeysWithValues: colors.shuffled()[0...3].map{ ($0.key, $0.value) })

        default:
            break
        }
    }

    func getNewColor() -> UIColor {
        return Array(current.values)[Int(arc4random_uniform(4))]
    }

    func getNewWord() -> String {
        return Array(current.keys)[Int(arc4random_uniform(4))]
    }

    func didSelectCorrect(chose: UIColor, correct: String) -> Bool {
        if chose == current[correct] {
            if mode == "Insane" {
                current = Dictionary(uniqueKeysWithValues: colors.shuffled()[0...3].map{ ($0.key, $0.value) })
            }
            return true
        }
        return false
    }

    func submitHighScore() {
        if !GKLocalPlayer.local.isAuthenticated {
            return
        }

        if high == score {
            let bestScore = GKScore(leaderboardIdentifier: leaderboardID)
            bestScore.value = Int64(high)
            GKScore.report([bestScore]) { (error) in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
            }
        }
    }

    func submitAchievements() {
        if !GKLocalPlayer.local.isAuthenticated {
            return
        }
        
        var identifiers = ["CS1", "CS2", "CS3", "CS4", "CS5", "CS6", "CS7", "CS8", "CS9"]
        GKAchievement.loadAchievements { (finishedAchievements, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }

            // Ignore completed achievements
            for achievement in finishedAchievements! {
                if achievement.isCompleted {
                    let index = identifiers.firstIndex(of: achievement.identifier)!
                    identifiers.remove(at: index)
                }
            }

            // Check unfinished achievements
            var achievements: [GKAchievement] = []

            if identifiers.contains("CS1") {
                if self.high >= 10 {
                    let temp = GKAchievement(identifier: "CS1")
                    achievements.append(temp)
                }
            }

            if identifiers.contains("CS2") {
                if self.high >= 50 {
                    let temp = GKAchievement(identifier: "CS2")
                    achievements.append(temp)
                }
            }

            if identifiers.contains("CS3") {
                if self.high >= 100 {
                    let temp = GKAchievement(identifier: "CS3")
                    achievements.append(temp)
                }
            }

            if identifiers.contains("CS4") {
                if self.high >= 250 {
                    let temp = GKAchievement(identifier: "CS4")
                    achievements.append(temp)
                }
            }

            if identifiers.contains("CS5") {
                if self.high >= 500 {
                    let temp = GKAchievement(identifier: "CS5")
                    achievements.append(temp)
                }
            }

            if identifiers.contains("CS6") {
                if self.high >= 1000 {
                    let temp = GKAchievement(identifier: "CS6")
                    achievements.append(temp)
                }
            }

            if identifiers.contains("CS7") {
                if self.score == 0 {
                    let temp = GKAchievement(identifier: "CS7")
                    achievements.append(temp)
                }
            }

            if identifiers.contains("CS8") {
                if UserDefaults.standard.integer(forKey: "gamesPlayed") >= 100 {
                    let temp = GKAchievement(identifier: "CS8")
                    achievements.append(temp)
                }
            }

            if identifiers.contains("CS9") {
                if UserDefaults.standard.bool(forKey: "leaderboardChecked") {
                    let temp = GKAchievement(identifier: "CS9")
                    achievements.append(temp)
                }
            }

            for achievement in achievements {
                achievement.percentComplete = 100.0
                achievement.showsCompletionBanner = true
            }

            GKAchievement.report(achievements, withCompletionHandler: { (error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
            })
        }
    }
}

