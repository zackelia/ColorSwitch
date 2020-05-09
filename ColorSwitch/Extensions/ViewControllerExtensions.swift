//
//  ViewControllerExtensions.swift
//  ColorSwitch
//
//  Created by Zack on 5/3/20.
//  Copyright © 2020 Zachary Elia. All rights reserved.
//

import GameKit

extension MenuViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
