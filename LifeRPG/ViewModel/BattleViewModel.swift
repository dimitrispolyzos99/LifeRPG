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
    @Published var maxPlayerHP: Int
    @Published var maxPlayerMana: Int
    @Published var maxEnemyHP = 50


    private let enemyMana = 10
    private var basicAttackDamage = 10
    private let enemyAttackDamage = 5
    private var judgementDamage = 15
    private var holyLightHeal = 15
    private let potionHeal = 10
    private let manaRegenPerTurn = 3
    private let xpReward = 50
    let judgementManaCost = 5
    private let levelUpCost = 100
    let holyLightManaCost = 10
    private let warriorHP = 60
    private let warriorMana = 10
    private let mageHP = 40
    private let mageMana = 60
    private let paladinHP = 70
    private let paladinMana = 20
    private let rogueHP = 40
    private let rogueMana = 30
    let executeHPCost = 5
    private var executeDamage = 30
    let fireballManaCost = 10
    private var fireballDamage = 40
    let garroteManaCost = 15
    private var garroteDamage = 20
    let frostballManaCost = 20
    private var frostballDamage = 25
    let assassinateManaCost = 20
    private var assassinateDamage = 50
    private var victoryRushDamage = 30
    let victoryRushManaCost = 10
    var victoryRushHeal = 10

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
        self.maxPlayerHP = initialMaxHP
        self.maxPlayerMana = initialMaxMana
        self.player.hp = initialMaxHP
        self.player.mana = initialMaxMana
    }

    
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
    
    
    
    var isGameOver: Bool {
        player.hp == 0
    }
    
    
    
    private func respawnEnemy(){
        enemy.isAlive = true
        maxEnemyHP += (player.stage * 2)
        enemy.hp = maxEnemyHP
        addLog("A new \(enemy.name) appears")
    }
    func levelUp() {
        player.level += 1
        player.xp = 0
        maxPlayerHP += ((player.level - 1) * 3)
        maxPlayerMana += ((player.level - 1) * 2)
        player.hp = maxPlayerHP
        player.mana = maxPlayerMana
        savePlayer()
        addLog("Congrats you leveled up")
    }
        
    
    private func resolveEnemyTurn(){
        if enemy.hp <= 0 {
            enemy.isAlive = false
            player.stage += 1
            player.xp += xpReward
            addLog("You killed the \(enemy.name)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                self.respawnEnemy()
            }
            if player.xp >= levelUpCost * player.level {
                levelUp()
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
            let scaledVictoryRushDamage = victoryRushDamage + ((player.level - 1) * 3)
            let scaledVictoryRushHeal = victoryRushHeal + ((player.level - 1) * 2)
            enemy.hp -= scaledVictoryRushDamage
            player.hp += scaledVictoryRushHeal
            addLog("\(player.playerClass.name) used \(player.playerClass.spellTwo) on \(enemy.name) and healed for \(scaledVictoryRushHeal) hp")
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
            let scaledAssassinateDamage = assassinateDamage + ((player.level - 1) * 3)
            enemy.hp -= scaledAssassinateDamage
            addLog("\(player.playerClass.name) used \(player.playerClass.spellTwo) and backstabed \(enemy.name) and did \(scaledAssassinateDamage) damage")
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
            let scaledGarroteDamage = garroteDamage + ((player.level - 1) * 2)
            enemy.hp -= scaledGarroteDamage
            addLog("\(player.playerClass.name) used \(player.playerClass.spellOne) and backstabed \(enemy.name) and did \(scaledGarroteDamage)")
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
            let scaledFireballDamage = fireballDamage + ((player.level - 1) * 2)
            enemy.hp -= scaledFireballDamage
            addLog("\(player.playerClass.name) casted \(player.playerClass.spellOne) on \(enemy.name) and did \(scaledFireballDamage)")
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
            let scaledFrostballDamage = frostballDamage + ((player.level - 1) * 3)
            enemy.hp -= scaledFrostballDamage
            addLog("\(player.playerClass.name) casted \(player.playerClass.spellTwo) on \(enemy.name) and did \(scaledFrostballDamage)")
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
            let scaledExecuteDamage = executeDamage + ((player.level - 1) * 2)
            enemy.hp -= executeDamage
            addLog("\(player.playerClass.name) sucrificed \(executeHPCost) HP and used \(player.playerClass.spellOne) on \(enemy.name) for \(scaledExecuteDamage) damage")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough HP")
        }
    }
    func holyLight(){
        if player.mana >= holyLightManaCost{
            player.mana -= holyLightManaCost
            let scaledHolyLightHeal = holyLightHeal + ((player.level - 1) * 2)
            player.hp = min(player.hp + scaledHolyLightHeal, maxPlayerHP)
            addLog("\(player.playerClass.name) used \(player.playerClass.spellOne) and healed for \(scaledHolyLightHeal) HP")
            enemyAttack()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func judgement(){
        if player.mana >= judgementManaCost{
            player.mana -= judgementManaCost
            let scaledJudgementDamage = judgementDamage + ((player.level - 1) * 2)
            enemy.hp -= judgementDamage
            addLog("\(player.playerClass.name) used \(player.playerClass.spellOne) on \(enemy.name) and did \(scaledJudgementDamage) damage")
            murlocTakesDamage()
            resolveEnemyTurn()
        }
        else {
            addLog("Not enough mana")
        }
    }
    func spellOne(){
        switch player.playerClass {
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
        switch player.playerClass {
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

    func applyClass(_ selectedClass: PlayerClass){
        updateMaxStats(for: selectedClass)
        maxEnemyHP = 50
        player = Player(sellectedClass: selectedClass)
        enemy = Enemy(hp: maxEnemyHP , mana: enemyMana , isAlive: true, name: "\(enemy.name)")
        player.hp = maxPlayerHP
        player.mana = maxPlayerMana
        player.stage = 1

        battleLog = ["New character created"]
        addLog("Battle started")
        savePlayer()
    }
}

