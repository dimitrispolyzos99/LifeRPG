//
//  PlayerStatsService.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 2/6/26.
//

import Foundation

protocol PlayerStatsService {
    func levelUp(_ player: Player) -> Player
}

class GamePlayerStatsService: PlayerStatsService {
    func levelUp(_ player: Player) -> Player {
        var updated = player
        updated.level += 1
        updated.xp = 0
        updated.maxHP += 3
        updated.maxMana += 2
        updated.hp = updated.maxHP
        updated.mana = updated.maxMana
        return updated
    }
}
