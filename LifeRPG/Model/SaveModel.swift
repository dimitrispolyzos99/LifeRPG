//
//  SaveModel.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 17/3/26.
//

import Foundation

struct SaveData: Codable {
    var player: Player
    var enemy: Enemy
    var maxPlayerHP: Int
    var maxPlayerMana: Int
    var maxEnemyHP: Int
}
