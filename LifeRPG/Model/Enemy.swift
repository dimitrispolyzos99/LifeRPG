//
//  Enemy.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 12/3/26.
//

import Foundation

struct Enemy : Codable, Equatable  {
    var hp: Int
    var mana: Int
    var isAlive: Bool
    var name : String
    
}

