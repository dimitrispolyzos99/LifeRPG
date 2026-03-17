//
//  Model.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 12/3/26.
//

import Foundation

struct Player : Codable {

    var playerClass: PlayerClass
    var hp: Int
    var mana: Int
    var xp: Int
    var level: Int
    var stage : Int


    init(sellectedClass: PlayerClass) {
        self.playerClass = sellectedClass
        self.hp = playerClass.maxHP
        self.mana = playerClass.maxMana
        self.xp = 0
        self.level = 1
        self.stage = 1
    }

}

struct PlayerClass : Equatable, Codable {
    let name: String
    let maxHP: Int
    let maxMana: Int
    var spellOne: String
    var spellTwo: String
}

let paladin = PlayerClass(
    name: "Paladin",
    maxHP: 70,
    maxMana: 20,
    spellOne: "Judgement",
    spellTwo: "Holy Light",
)

let mage = PlayerClass(
    name: "Mage",
    maxHP: 50,
    maxMana: 40,
    spellOne: "Fireball",
    spellTwo: "Frostbolt"
)

let rogue = PlayerClass(
    name: "Rogue",
    maxHP: 60,
    maxMana: 25,
    spellOne: "Garote",
    spellTwo: "Assassinate"
)

let warrior = PlayerClass(
    name: "Warrior",
    maxHP: 60,
    maxMana: 10,
    spellOne: "Execute",
    spellTwo: "Victory Rush"
)
