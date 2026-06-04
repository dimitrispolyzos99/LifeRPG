//
//  Spell.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 3/6/26.
//

import Foundation



struct Spell: Codable, Equatable {
    let name: String
    let damage: Int
    let heal: Int
    let manaCost: Int
    let hpCost: Int
    let scalingPerLevel: Int
}

// MARK: - Warrior
let executeSpell = Spell(name: "Execute", damage: 30, heal: 0, manaCost: 0, hpCost: 5, scalingPerLevel: 2)
let victoryRushSpell = Spell(name: "Victory Rush", damage: 30, heal: 10, manaCost: 10, hpCost: 0, scalingPerLevel: 3)

// MARK: - Paladin
let judgementSpell = Spell(name: "Judgement", damage: 15, heal: 0, manaCost: 5, hpCost: 0, scalingPerLevel: 2)
let holyLightSpell = Spell(name: "Holy Light", damage: 0, heal: 15, manaCost: 10, hpCost: 0, scalingPerLevel: 2)

// MARK: - Mage
let fireballSpell = Spell(name: "Fireball", damage: 40, heal: 0, manaCost: 10, hpCost: 0, scalingPerLevel: 2)
let frostballSpell = Spell(name: "Frostbolt", damage: 25, heal: 0, manaCost: 20, hpCost: 0, scalingPerLevel: 3)

// MARK: - Rogue
let garroteSpell = Spell(name: "Garrote", damage: 20, heal: 0, manaCost: 15, hpCost: 0, scalingPerLevel: 2)
let assassinateSpell = Spell(name: "Assassinate", damage: 50, heal: 0, manaCost: 20, hpCost: 0, scalingPerLevel: 3)
