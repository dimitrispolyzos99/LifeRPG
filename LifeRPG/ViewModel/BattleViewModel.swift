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
    
    
    @Published var enemyHP = 50
    @Published var playerHP = 70
    @Published var battleLog: [String] = ["Battle started"]
    @Published var xp = 0
    @Published var level = 1
    @Published var playerMana = 20
    @Published var enemyHit = false
    @Published var playerHit = false
    @Published var enemyIsAlive = true
    
    var isGameOver: Bool {
        playerHP == 0
    }
    
    func attackMurloc(){
            murlocTakesDamage()
            enemyHP -= basicAttackDamage
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
        playerHP = min(playerHP + potionHeal, maxPlayerHP)
        addLog("Paladin used Health Potion")
        enemyAttack()
    }
    private func enemyAttack() {
        playerHit = true
        playerMana = min(playerMana + manaRegenPerTurn, maxPlayerMana)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.playerHit = false
        }
        playerHP = max(playerHP - enemyAttackDamage, 0)
        if playerHP == 0{
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
        enemyHP = maxEnemyHP
        playerHP = maxPlayerHP
        playerMana = maxPlayerMana
        enemyIsAlive = true
        enemyHit = false
        playerHit = false
        battleLog = ["Battle restarted"]
    }
    private func respawnEnemy(){
        enemyIsAlive = true
        enemyHP = maxEnemyHP
        addLog("A new Murloc appears")
    }
    
    private func resolveEnemyTurn(){
        if enemyHP <= 0 {
            enemyIsAlive = false
            xp += xpReward
            addLog("You killed the Murloc")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                self.respawnEnemy()
            }
            if xp >= levelUpCost * level {
                level += 1
                xp = 0
                addLog("Congrats you leveled up")
            }
        } else {
            enemyAttack()
        }
    }
    func holyLight(){
        if playerMana >= holyLightManaCost{
            playerMana -= holyLightManaCost
            playerHP = min(playerHP + holyLightHeal, maxPlayerHP)
            addLog("Paladin used holy light and healed for 15 HP")
            enemyAttack()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func judgement(){
        if playerMana >= judgementManaCost{
            playerMana -= judgementManaCost
            enemyHP -= judgementDamage
            addLog("Paladin used judgement on Murloc")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
}

