//
//  SaveModel.swift
//  LifeRPG
//
//  Created by Dimitris Polyzos on 17/3/26.
//

import Foundation

struct SaveData: Codable, Equatable {
    var player: Player
    var enemy: Enemy
    var maxEnemyHP: Int
    var currentArena: String
}
