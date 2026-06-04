//
//  Enemy.swift
//  LifeRPG
//
//  Created by Dimitris Polyzos on 12/3/26.
//

import Foundation

struct Enemy : Codable, Equatable  {
    var hp: Int
    var mana: Int
    var isAlive: Bool
    var name : String
    var attackDamage: Int
}

