//
//  BattleViewModel.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 11/3/26.
//

import Foundation
import Combine


class BattleViewModel: ObservableObject {

//    var maxPlayerHP = 100
//    var maxPlayerMana = 40
    @Published var maxPlayerHP: Int = 0
    @Published var maxPlayerMana: Int = 0
    @Published var maxEnemyHP = 50


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

    
    private func updateMaxStats(for playerClass: PlayerClass) {
        switch playerClass {
        case warrior:
            maxPlayerHP = warriorHP
            maxPlayerMana = warriorMana
        case mage:
            maxPlayerHP = mageHP
            maxPlayerMana = mageMana
        case paladin:
            maxPlayerHP = paladinHP
            maxPlayerMana = paladinMana
        case rogue:
            maxPlayerHP = rogueHP
            maxPlayerMana = rogueMana
        default:
            maxPlayerHP = 100
            maxPlayerMana = 40
        }
    }
    
    @Published var playerClass: PlayerClass = warrior
    @Published var player: Player
    @Published var enemy = Enemy(
        hp: 50,
        mana: 20,
        isAlive: true,
        name: "Murloc"
    )
    @Published var battleLog: [String] = ["Battle started"]
    @Published var enemyHit = false
    @Published var playerHit = false
    
    
    init() {
        let initialClass: PlayerClass = warrior

        let initialMaxHP: Int
        let initialMaxMana: Int
        switch initialClass {
        case warrior:
            initialMaxHP = warriorHP
            initialMaxMana = warriorMana
        case mage:
            initialMaxHP = mageHP
            initialMaxMana = mageMana
        case paladin:
            initialMaxHP = paladinHP
            initialMaxMana = paladinMana
        case rogue:
            initialMaxHP = rogueHP
            initialMaxMana = rogueMana
        default:
            initialMaxHP = 100
            initialMaxMana = 40
        }

        self.player = Player(sellectedClass: initialClass)
        self.playerClass = initialClass
        self.maxPlayerHP = initialMaxHP
        self.maxPlayerMana = initialMaxMana
        self.player.hp = initialMaxHP
        self.player.mana = initialMaxMana
    }
    
    var isGameOver: Bool {
        player.hp == 0
    }
    

    private func respawnEnemy(){
        enemy.isAlive = true
        maxEnemyHP += (player.stage * 10)
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
                player.stage += 1
                savePlayer()
                addLog("Congrats you leveled up")
            }
        } else {
            enemyAttack()
        }
    }
    private func enemyAttack() {
        playerHit = true
        player.mana = min(player.mana + manaRegenPerTurn, maxPlayerMana)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.playerHit = false
        }
        player.hp = max(player.hp - enemyAttackDamage, 0)
        if player.hp == 0{
            addLog("\(player.playerClass.name) was defeated")
        } else {
            addLog("\(enemy.name) attacked \(player.playerClass.name) for \(enemyAttackDamage + (player.stage * 2)) dmg")
        }
    }
    private func murlocTakesDamage() {
        enemyHit = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.enemyHit = false
        }
    }
    
    
    func savePlayer() {
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(player) {
            UserDefaults.standard.set(data, forKey: "player")
        }
    }
    func loadPlayer() {
        if let savedPlayerData = UserDefaults.standard.data(forKey: "player") {
            let decoder = JSONDecoder()
            
            if let loadedPlayer = try? decoder.decode(Player.self, from: savedPlayerData) {
                player = loadedPlayer
            }
        }
    }
    func attackMurloc(){
            murlocTakesDamage()
            enemy.hp -= basicAttackDamage
        addLog("\(player.playerClass.name) attacks \(enemy.name) for \(basicAttackDamage) dmg")
            resolveEnemyTurn()
        }
    func addLog(_ message: String) {
        battleLog.append(message)

        if battleLog.count > 20 {
            battleLog.removeFirst()
        }
    }
    func usePotion() {
        player.hp = min(player.hp + potionHeal, maxPlayerHP)
        addLog("\(player.playerClass.name) used Health Potion")
        enemyAttack()
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
    func holyLight(){
        if player.mana >= holyLightManaCost{
            player.mana -= holyLightManaCost
            player.hp = min(player.hp + holyLightHeal, maxPlayerHP)
            addLog("\(player.playerClass.name) used holy light and healed for 15 HP")
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
            addLog("\(player.playerClass.name) used judgement on Murloc")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func applyClass(_ selectedClass: PlayerClass){
        player.playerClass = selectedClass
        updateMaxStats(for: selectedClass)
        player.hp = maxPlayerHP
        player.mana = maxPlayerMana
    }
}

