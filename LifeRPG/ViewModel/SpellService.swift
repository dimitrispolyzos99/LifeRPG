//
//  SpellService.swift
//  LifeRPG
//
//  Created by Dimitris Polyzos on 3/6/26.
//

import Foundation

protocol SpellService {
    func cast(_ spell: Spell, player: inout Player, enemy: inout Enemy)
}

class GameSpellService: SpellService {
    func cast(_ spell: Spell, player: inout Player, enemy: inout Enemy) {
        let scaledSpellDamage = spell.damage + ((player.level - 1) * spell.scalingPerLevel)
        player.hp -= spell.hpCost
        player.mana -= spell.manaCost
        enemy.hp -= scaledSpellDamage
        player.hp = min(player.hp + spell.heal, player.maxHP)

    }
}
