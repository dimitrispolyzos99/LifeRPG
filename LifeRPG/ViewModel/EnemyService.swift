//
//  EnemyService.swift
//  LifeRPG
//
//  Created by Dimitris Polyzos on 1/6/26.
//

import Foundation

protocol EnemyService {
    func spawnEnemy(for stage: Int) -> Enemy
}

class GameEnemyService: EnemyService {
    func spawnEnemy(for stage: Int) -> Enemy {
        let hp = 50 + ((stage - 1) * 5)
        let name: String
        switch stage {
        case 1...3:
            name = "Murloc"
        case 4...6:
            name = "Goblin"
        case 7...9:
            name = "Skeleton"
        default:
            name = "Boss"
        }
        let damage = 5 + ((stage - 1) * 2)
        return Enemy(hp: hp, mana: 10, isAlive: true, name: name, attackDamage: damage)
    }
}
