//
//  BattleViewModel.swift
//  LifeRPG
//
//  Created by Dimitris Poluzos on 11/3/26.
//

import Foundation
import Combine

@MainActor
class BattleViewModel: ObservableObject {


    @Published var maxEnemyHP = 50
    @Published var currentArena: String
    @Published var player: Player
    @Published var enemy: Enemy
    @Published var enemyHit = false
    @Published var playerHit = false


    private var basicAttackDamage = 10
    private let judgementDamage = 15
    private let holyLightHeal = 15
    private let potionHeal = 10
    private let manaRegenPerTurn = 3
    private let xpReward = 50
    let judgementManaCost = 5
    private let levelUpCost = 100
    let holyLightManaCost = 10
    let executeHPCost = 5
    private let executeDamage = 30
    let fireballManaCost = 10
    private let fireballDamage = 40
    let garroteManaCost = 15
    private let garroteDamage = 20
    let frostballManaCost = 20
    private let frostballDamage = 25
    let assassinateManaCost = 20
    private let assassinateDamage = 50
    private let victoryRushDamage = 30
    let victoryRushManaCost = 10
    let victoryRushHeal = 10
    var classColor = "warriorColor"
   
    let battleLog: LogService
    let saveDataService: SaveService
    let enemyService: EnemyService
    let playerStatsService: PlayerStatsService
    
    init(battleLog: LogService? = nil, saveDataService: SaveService? = nil, enemyService: EnemyService? = nil, playerStatsService: PlayerStatsService? = nil) {
        self.battleLog = battleLog ?? BattleLogService()
        self.saveDataService = saveDataService ?? SaveGameService()
        self.enemyService = enemyService ?? GameEnemyService()
        self.playerStatsService = playerStatsService ?? GamePlayerStatsService()

        let initialClass: PlayerClass = warrior
        let initialArena = "Coast"
        self.currentArena = initialArena
        self.player = Player(sellectedClass: initialClass)
        self.enemy = self.enemyService.spawnEnemy(for: 1)
    }

    
    private func updateMaxStats(for playerClass: PlayerClass) {
        player.maxHP = playerClass.maxHP
        player.maxMana = playerClass.maxMana
    }
    
    func updateArena(){
        switch player.stage{
        case 1...3:
            currentArena = "Coast"
        case 4...6:
            currentArena = "Forest"
        case 7...9:
            currentArena = "HauntedHouse"
        default:
            currentArena = "Volcano"
        }
    }
    
    var isGameOver: Bool {
        player.hp == 0
    }
    
    func respawnEnemy(){
        enemy = enemyService.spawnEnemy(for: player.stage)
        maxEnemyHP = enemy.hp
        updateArena()
        battleLog.addLog("\(enemy.name) has appeared")
    }
    private func levelUp() {
        player = playerStatsService.levelUp(player)
        saveGame()
        battleLog.addLog("Congrats you leveled up")
    }
    private func resolveEnemyTurn(){
        if enemy.hp <= 0 {
            enemy.isAlive = false
            saveGame()
            player.stage += 1
            player.xp += xpReward
            battleLog.addLog("You killed the \(enemy.name)")
            
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
        
        playerHit = true
        player.mana = min(player.mana + manaRegenPerTurn, player.maxMana)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            self.playerHit = false
        }
        player.hp = max(player.hp - enemy.attackDamage, 0)
        if player.hp == 0{
            battleLog.addLog("\(player.playerClass.name) was defeated")
        } else {
            battleLog.addLog("\(enemy.name) attacked \(player.playerClass.name) for \(enemy.attackDamage) dmg")
        }
    }
    private func enemyTakesDamage() {
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
            battleLog.addLog("\(player.playerClass.name) used \(player.playerClass.spellTwo) on \(enemy.name) and healed for \(scaledVictoryRushHeal) hp")
            enemyTakesDamage()
            resolveEnemyTurn()
        }
        else {
            battleLog.addLog("Not enough mana")
        }
    }
    func assasinate(){
        if player.mana >= assassinateManaCost{
            player.mana -= assassinateManaCost
            let scaledAssassinateDamage = assassinateDamage + ((player.level - 1) * 3)
            enemy.hp -= scaledAssassinateDamage
            battleLog.addLog("\(player.playerClass.name) used \(player.playerClass.spellTwo) and backstabed \(enemy.name) and did \(scaledAssassinateDamage) damage")
            enemyTakesDamage()
            resolveEnemyTurn()
        }
        else {
            battleLog.addLog("Not enough mana")
        }
    }
    func garrote(){
        if player.mana >= garroteManaCost{
            player.mana -= garroteManaCost
            let scaledGarroteDamage = garroteDamage + ((player.level - 1) * 2)
            enemy.hp -= scaledGarroteDamage
            battleLog.addLog("\(player.playerClass.name) used \(player.playerClass.spellOne) and backstabed \(enemy.name) and did \(scaledGarroteDamage)")
            enemyTakesDamage()
            resolveEnemyTurn()
        }
        else {
            battleLog.addLog("Not enough mana")
        }
    }
    func fireball(){
        if player.mana >= fireballManaCost{
            player.mana -= fireballManaCost
            let scaledFireballDamage = fireballDamage + ((player.level - 1) * 2)
            enemy.hp -= scaledFireballDamage
            battleLog.addLog("\(player.playerClass.name) casted \(player.playerClass.spellOne) on \(enemy.name) and did \(scaledFireballDamage)")
            enemyTakesDamage()
            resolveEnemyTurn()
        }
        else {
            battleLog.addLog("Not enough mana")
        }
    }
    func frostball(){
        if player.mana >= frostballManaCost{
            player.mana -= frostballManaCost
            let scaledFrostballDamage = frostballDamage + ((player.level - 1) * 3)
            enemy.hp -= scaledFrostballDamage
            battleLog.addLog("\(player.playerClass.name) casted \(player.playerClass.spellTwo) on \(enemy.name) and did \(scaledFrostballDamage)")
            enemyTakesDamage()
            resolveEnemyTurn()
        }
        else {
            battleLog.addLog("Not enough mana")
        }
    }
    func execute() {
        if player.hp >= executeHPCost{
            player.hp -= executeHPCost
            let scaledExecuteDamage = executeDamage + ((player.level - 1) * 2)
            enemy.hp -= scaledExecuteDamage
            battleLog.addLog("\(player.playerClass.name) sucrificed \(executeHPCost) HP and used \(player.playerClass.spellOne) on \(enemy.name) for \(scaledExecuteDamage) damage")
            enemyTakesDamage()
            resolveEnemyTurn()
        }
        else {
            battleLog.addLog("Not enough HP")
        }
    }
    func holyLight(){
        if player.mana >= holyLightManaCost{
            player.mana -= holyLightManaCost
            let scaledHolyLightHeal = holyLightHeal + ((player.level - 1) * 2)
            player.hp = min(player.hp + scaledHolyLightHeal, player.maxHP)
            battleLog.addLog("\(player.playerClass.name) used \(player.playerClass.spellOne) and healed for \(scaledHolyLightHeal) HP")
            enemyAttack()
        }
        else {
            battleLog.addLog("Not enough mana")
        }
    }
    func judgement(){
        if player.mana >= judgementManaCost{
            player.mana -= judgementManaCost
            let scaledJudgementDamage = judgementDamage + ((player.level - 1) * 2)
            enemy.hp -= scaledJudgementDamage
            battleLog.addLog("\(player.playerClass.name) used \(player.playerClass.spellOne) on \(enemy.name) and did \(scaledJudgementDamage) damage")
            enemyTakesDamage()
            resolveEnemyTurn()
        }
        else {
            battleLog.addLog("Not enough mana")
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
    func saveGame() {
        let saveData = SaveData(
            player: player,
            enemy: enemy,
            maxEnemyHP: maxEnemyHP,
            currentArena: currentArena
        )
        saveDataService.saveGame(saveData)
    }
    func loadGame() {
        if let loadedSave = saveDataService.loadGame(){
                player = loadedSave.player
                enemy = loadedSave.enemy
                player.maxHP = loadedSave.player.maxHP
                player.maxMana = loadedSave.player.maxMana
                maxEnemyHP = loadedSave.maxEnemyHP
                currentArena = loadedSave.currentArena
                
                enemyHit = false
                playerHit = false
                battleLog.addLog("Game loaded")
            }
        }
    
    
    func attackEnemy(){
            enemyTakesDamage()
            enemy.hp -= basicAttackDamage
        battleLog.addLog("\(player.playerClass.name) attacks \(enemy.name) for \(basicAttackDamage) dmg")
            resolveEnemyTurn()
        }

    
    func usePotion() {
        player.hp = min(player.hp + potionHeal, player.maxHP)
        battleLog.addLog("\(player.playerClass.name) used Health Potion")
        enemyAttack()
    }
    func restartBattle(){
        enemy.hp = maxEnemyHP
        player.hp = player.maxHP
        player.mana = player.maxMana
        enemy.isAlive = true
        enemyHit = false
        playerHit = false
        battleLog.addLog("Battle restarted")
    }
    func resetGame() {
        player.stage = 1
        respawnEnemy()
        player.hp = player.maxHP
        player.mana = player.maxMana
    }
    func applyClass(_ selectedClass: PlayerClass){
        updateMaxStats(for: selectedClass)
        player = Player(sellectedClass: selectedClass)
        applyClassColor()
        resetGame()

        battleLog.addLog("New character created")
        battleLog.addLog("Battle started")
        saveGame()
    }

    func applyClassColor(){
        switch player.playerClass {
        case warrior:
            classColor = "warriorColor"
        case rogue:
            classColor = "rogueColor"
        case mage:
            classColor = "mageColor"
        default:
            classColor = "paladinColor"
        }
    }
    
}

