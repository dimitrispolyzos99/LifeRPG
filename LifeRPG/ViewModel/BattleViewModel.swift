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
    private let executeHPCost = 5
    private let executeDamage = 30
    private let fireballManaCost = 10
    private let fireballDamage = 40
    private let garroteManaCost = 15
    private let garroteDamage = 20
    private let frostballManaCost = 20
    private let frostballDamage = 25
    private let assassinateManaCost = 20
    private let assassinateDamage = 50
    private let victoryRushDamage = 30
    private let victoryRushManaCost = 10
    private let victoryRushHeal = 10


    
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
        
        let scaledDamage = enemyAttackDamage + (player.stage * 2)
        
        playerHit = true
        player.mana = min(player.mana + manaRegenPerTurn, maxPlayerMana)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.playerHit = false
        }
        player.hp = max(player.hp - scaledDamage, 0)
        if player.hp == 0{
            addLog("\(player.playerClass.name) was defeated")
        } else {
            addLog("\(enemy.name) attacked \(player.playerClass.name) for \(scaledDamage) dmg")
        }
    }
    private func murlocTakesDamage() {
        enemyHit = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.enemyHit = false
        }
    }
    
    
    
    
    
    func victoryRush(){
        if player.mana >= victoryRushManaCost {
            player.mana -= victoryRushManaCost
            enemy.hp -= victoryRushDamage
            player.hp += victoryRushHeal
            addLog("\(player.playerClass.name) used \(player.playerClass.spellTwo) on \(enemy.name) and healed for \(victoryRushHeal) hp")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func assasinate(){
        if player.mana >= assassinateManaCost{
            player.mana -= assassinateManaCost
            enemy.hp -= assassinateDamage
            addLog("\(player.playerClass.name) used \(player.playerClass.spellTwo) and backstabed \(enemy.name)")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func garrote(){
        if player.mana >= garroteManaCost{
            player.mana -= garroteManaCost
            enemy.hp -= garroteDamage
            addLog("\(player.playerClass.name) used \(player.playerClass.spellOne) and backstabed \(enemy.name)")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func fireball(){
        if player.mana >= fireballManaCost{
            player.mana -= fireballManaCost
            enemy.hp -= fireballDamage
            addLog("\(player.playerClass.name) casted \(player.playerClass.spellOne) on \(enemy.name)")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func frostball(){
        if player.mana >= frostballManaCost{
            player.mana -= frostballManaCost
            enemy.hp -= frostballDamage
            addLog("\(player.playerClass.name) casted \(player.playerClass.spellTwo) on \(enemy.name)")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func execute() {
        if player.hp >= executeHPCost{
            player.hp -= executeHPCost
            enemy.hp -= executeDamage
            addLog("\(player.playerClass.name) sucrificed \(executeHPCost) HP and used \(player.playerClass.spellOne) on \(enemy.name)")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough HP")
        }
    }
    func spellOne(){
        switch playerClass {
        case warrior:
            execute()
        case paladin:
            judgement()
        case mage:
            fireball()
        case rogue:
            garrote()
        default :
            break
        }
    }
    func spellTwo(){
        switch playerClass {
        case warrior:
            victoryRush()
        case paladin:
            holyLight()
        case mage:
            frostball()
        case rogue:
            assasinate()
        default :
            break
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
            addLog("\(player.playerClass.name) used \(player.playerClass.spellOne) on \(enemy.name)")
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

