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
//    var maxPlayerHP = 100
//    var maxPlayerMana = 40
    @Published var maxPlayerHP = 20
    @Published var maxPlayerMana = 20

    
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
    private let warriorHP = 60
    private let warriorMana = 10
    private let mageHP = 40
    private let mageMana = 60
    private let paladinHP = 70
    private let paladinMana = 20
    private let rogueHP = 40
    private let rogueMana = 30
    

    @Published var player = Player(
        hp: 70,
        mana: 20,
        xp: 0,
        level: 1,
        playerClass: .paladin
    )
    @Published var enemy = Enemy(
        hp: 50,
        mana: 20,
        isAlive: true,
        name: "Murloc"
    )
    @Published var battleLog: [String] = ["Battle started"]
    @Published var enemyHit = false
    @Published var playerHit = false

    
    var isGameOver: Bool {
        player.hp == 0
    }
    func applyClass(_ chosenClass: PlayerClass){
        player.playerClass = chosenClass
        
        switch player.playerClass  {
            case .warrior :
            player.hp = warriorHP
            player.mana = warriorMana
            maxPlayerHP = warriorHP
            maxPlayerMana = warriorMana
            
        case .mage :
            player.mana = mageHP
            player.mana = mageMana
            maxPlayerHP = mageHP
            maxPlayerMana = mageMana
            
        case .paladin :
            player.mana = paladinHP
            player.mana = paladinMana
            maxPlayerHP = paladinHP
            maxPlayerMana = paladinMana
            
        case .rogue :
            player.mana = rogueHP
            player.mana = rogueMana
            maxPlayerHP = rogueHP
            maxPlayerMana = rogueMana
            
            break
        }
    }
    func attackMurloc(){
            murlocTakesDamage()
            enemy.hp -= basicAttackDamage
        addLog("\(player.playerClass.rawValue) attacks \(enemy.name) for \(basicAttackDamage) dmg")
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
        addLog("\(player.playerClass.rawValue) used Health Potion")
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
            addLog("\(player.playerClass.rawValue) was defeated")
        } else {
            addLog("\(enemy.name) attacked \(player.playerClass.rawValue) for \(enemyAttackDamage) dmg")
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
        addLog("A new \(enemy.name) appears")
    }
    
    private func resolveEnemyTurn(){
        if enemy.hp <= 0 {
            enemy.isAlive = false
            player.xp += xpReward
            addLog("You killed the \(enemy.name)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                self.respawnEnemy()
            }
            if player.xp >= levelUpCost * player.level {
                player.level += 1
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
            addLog("\(player.playerClass.rawValue) used holy light and healed for 15 HP")
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
            addLog("\(player.playerClass.rawValue) used judgement on Murloc")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
}

