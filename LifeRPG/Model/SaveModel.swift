//
//  SaveModel.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 17/3/26.
//

import Foundation

struct SaveData: Codable, Equatable {
    var player: Player
    var enemy: Enemy
    var maxEnemyHP: Int
    var currentArena: String
}
