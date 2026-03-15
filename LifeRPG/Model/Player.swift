//
//  Model.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 12/3/26.
//

import Foundation

struct Player {
    var hp: Int
    var mana: Int
    var xp: Int
    var level: Int
    var playerClass: PlayerClass
}

enum PlayerClass : String {
    case warrior = "Warrior"
    case mage = "Mage"
    case paladin = "Paladin"
    case rogue = "Rogue"
}
