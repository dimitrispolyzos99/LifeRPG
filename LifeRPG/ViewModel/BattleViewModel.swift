//
//  BattleViewModel.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 11/3/26.
//

import Foundation
import Combine


class BattleViewModel: ObservableObject {
    private let maxEnemyHP = 50
    private let maxPlayerHP = 70
    private let maxPlayerMana = 20
    
    private let basicAttackDamage = 10
    private let enemyAttackDamage = 5
    private let judgementDamage = 15
    private let holyLightHeal = 15
    private let potionHeal = 10
    private let manaRegenPerTurn = 3
    private let xpReward = 50
    private let judgementManaCost = 5
    private let levelUpCost = 100
    private let holyLightManaCost = 10
    
    
    @Published var player = Player(
        hp: 70,
        mana: 20,
        xp: 0,
        level: 1
    )
    @Published var enemy = Enemy(
        hp: 50,
        mana: 10,
        isAlive: true
    )
    @Published var battleLog: [String] = ["Battle started"]
    @Published var enemyHit = false
    @Published var playerHit = false

    
    var isGameOver: Bool {
        player.hp == 0
    }
    
    func attackMurloc(){
            murlocTakesDamage()
            enemy.hp -= basicAttackDamage
            addLog("Paladin attacks Murloc for 10 dmg")
            resolveEnemyTurn()
        }
    private func addLog(_ message: String) {
        battleLog.append(message)

        if battleLog.count > 20 {
            battleLog.removeFirst()
        }
    }
    func usePotion() {
        player.hp = min(player.hp + potionHeal, maxPlayerHP)
        addLog("Paladin used Health Potion")
        enemyAttack()
    }
    private func enemyAttack() {
        playerHit = true
        player.mana = min(player.mana + manaRegenPerTurn, maxPlayerMana)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.playerHit = false
        }
        player.hp = max(player.hp - enemyAttackDamage, 0)
        if player.hp == 0{
            addLog("Paladin was defeated")
        } else {
            addLog("Murloc attacked Paladin for 5 dmg")
        }
    }
    private func murlocTakesDamage() {
        enemyHit = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.enemyHit = false
        }
    }
    func restartBattle(){
        enemy.hp = maxEnemyHP
        player.hp = maxPlayerHP
        player.mana = maxPlayerMana
        enemy.isAlive = true
        enemyHit = false
        playerHit = false
        battleLog = ["Battle restarted"]
    }
    private func respawnEnemy(){
        enemy.isAlive = true
        enemy.hp = maxEnemyHP
        addLog("A new Murloc appears")
    }
    
    private func resolveEnemyTurn(){
        if enemy.hp <= 0 {
            enemy.isAlive = false
            player.xp += xpReward
            addLog("You killed the Murloc")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                self.respawnEnemy()
            }
            if player.xp >= levelUpCost * level {
                level += 1
                player.xp = 0
                addLog("Congrats you leveled up")
            }
        } else {
            enemyAttack()
        }
    }
    func holyLight(){
        if player.mana >= holyLightManaCost{
            player.mana -= holyLightManaCost
            player.hp = min(player.hp + holyLightHeal, maxPlayerHP)
            addLog("Paladin used holy light and healed for 15 HP")
            enemyAttack()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func judgement(){
        if player.mana >= judgementManaCost{
            player.mana -= judgementManaCost
            enemy.hp -= judgementDamage
            addLog("Paladin used judgement on Murloc")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
}

